import datetime
import json
import re

import joblib
import pandas as pd

from src.apis.external.unsplash import get_unsplash_image_urls
from src.apis.garden.models import RecommendedPlants
from src.apis.garden.recommendation.ai_models.generate import generate_response
from src.apis.garden.recommendation.data_process.process import get_processed_data
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor

BASE_DIR = Path(__file__).resolve().parent.parent.parent.parent


class Prediction:
    def __init__(self, data, address="Abbottabad,Pakistan", is_more=True):
        self.file1_model1 = BASE_DIR / 'garden/recommendation/ai_models/model1/k_clustering4.pkl'
        self.file2_model1 = BASE_DIR / 'garden/recommendation/ai_models/model1/processed_data4.pkl'
        self.scaler_model1 = BASE_DIR / 'garden/recommendation/ai_models/model1/scaler4.pkl'

        self.processed_model_model1 = None
        self.processed_data = None
        self.predictions_model1 = None
        self.address = address
        self.is_more = is_more
        # Load data and models
        self.load_data_and_models(data)

    def load_data_and_models(self, data):
        self.processed_data = get_processed_data(data=data)
        self.processed_model_model1 = pd.read_pickle(self.file2_model1)

    def get_predictions(self, data, scaler, loaded_model):
        data_ = pd.DataFrame(data, index=[0])
        X_new_scaled = scaler.transform(data_)
        predictions = loaded_model.predict(X_new_scaled)
        return predictions

    def get_predictions_parallel(self, data, executor):
        # Load model1
        scaler_model1 = joblib.load(self.scaler_model1)
        loaded_model_model1 = joblib.load(self.file1_model1)

        # Run both models in parallel
        future_model1 = executor.submit(self.get_predictions, data, scaler_model1, loaded_model_model1)
        predictions_model1 = future_model1.result()

        return predictions_model1

    def filter_predictions(self):

        executor = ThreadPoolExecutor()
        self.predictions_model1 = self.get_predictions_parallel(self.processed_data, executor)
        executor.shutdown()

        return self.combine_predictions()

    def combine_predictions(self):
        date = datetime.date.today()
        exist_rec = get_existing_recommendation(address=self.address, date=date)
        if self.is_more=="True":
            print("IS MORE>....")
            predictions_model1 = self.process_predictions(self.predictions_model1, self.processed_model_model1)
            return predictions_model1

        if exist_rec is None:
            try:
                data = generate_response(self.address, date)
                data = extract_json_data(data)
                # Clean up the response text
                # data_cleaned = re.sub(r'^plants\s*=\s*', '', data.strip())
                # data_cleaned = re.sub(r'\s*;\s*$', '', data_cleaned)  # Remove trailing semicolons if present
                print("AFTER JSON : ",data)
                # Debug cleaned data

                try:
                    # Directly load the JSON data
                    d_data = json.loads(data)
                    print("predictions:   ..",d_data)
                except json.JSONDecodeError as e:

                    print(f"Error decoding JSON: {e}")
                    return None

                predictions = [
                    {
                        "name": plant["name"],
                        "category": plant["category"],
                        "bestgrow": plant["bestgrow"],
                        "network_image_address": get_unsplash_image_urls(f"Plant of {plant['name']}"),
                        "water_time" : plant['water_time']
                    }

                    for plant in d_data
                ]
                # predictions_model1 = predictions
                predictions_model1 = populate_data(address=self.address, date=date, predictions_model1=predictions)
                print(len(predictions_model1))


            except Exception as e:
                print("IN TOP..")
                print(e)
                predictions_model1 = self.process_predictions(self.predictions_model1, self.processed_model_model1)
        else:
            print("RECORD WAS ALREADY EXIST....")
            predictions_model1 = exist_rec
            print(predictions_model1)

            predictions_model1 = predictions_model1 +self.process_predictions(self.predictions_model1, self.processed_model_model1)
            print(len(predictions_model1))

        return predictions_model1

    def process_predictions(self, predictions, processed_model):
        cluster_to_seedId_names = processed_model.groupby('Cluster')['Seed_Name'].apply(list).to_dict()
        cluster_to_areas = processed_model.groupby('Cluster')['Best_Growing_Areas'].apply(list).to_dict()
        cluster_to_soils = processed_model.groupby('Cluster')['Soil_Types'].apply(list).to_dict()
        cluster_to_seed_id = processed_model.groupby('Cluster')['Seed_ID'].apply(list).to_dict()
        cluster_to_category = processed_model.groupby('Cluster')['Plant_Category'].apply(list).to_dict()


        predicted_cluster = predictions[0]
        predicted_names = cluster_to_seedId_names.get(predicted_cluster, [])
        predicted_areas = cluster_to_areas.get(predicted_cluster, [])
        predicted_seedId = cluster_to_seed_id.get(predicted_cluster, [])
        predicted_soil = cluster_to_soils.get(predicted_cluster, [])
        predicted_category = cluster_to_category.get(predicted_cluster, [])


        data = [
            {
                'id': seedId,
                'name': seedName,
                'bestgrow': areas,
                'category':category,
                'img': None,
                "water_time":None
            }
            for seedId, seedName, areas, soil ,category in zip(predicted_seedId, predicted_names, predicted_areas, predicted_soil,predicted_category)
        ]

        return data


def get_existing_recommendation(address, date):
    # Step 1: Check if data already exists for the given address and date
    existing_plants = RecommendedPlants.objects.filter(address=address, date=date)

    if existing_plants.exists():
        # Step 2: If data exists, convert the queryset to a list of dictionaries
        serialized_plants = [
            {
                "id": plant.pk,
                "name": plant.name,
                "category": plant.category,
                "bestgrow": plant.bestgrow,
                "img": plant.img,
                'water_time':plant.water_time

            }
            for plant in existing_plants
        ]
        return serialized_plants
    else:
        return None


def populate_data(address, date, predictions_model1):
    # Step 3: If data doesn't exist, populate new data using predictions_model1
    print("ENTER IN POPULATING DATA")
    new_plants = []
    for plant in predictions_model1:
        new_plant = RecommendedPlants(
            name=plant["name"],
            category=plant["category"],
            bestgrow=plant["bestgrow"],
            img=plant["network_image_address"],
            date=date,
            address=address,
            water_time=plant["water_time"]

        )
        new_plant.save()
        new_plants.append(new_plant)

    # Convert the queryset to a list of dictionaries
    serialized_plants = [
        {
            "id": plant.pk,
            "name": plant.name,
            "category": plant.category,
            "bestgrow": plant.bestgrow,
            "img": plant.img,
            'water_time':plant.water_time
        }
        for plant in new_plants
    ]

    # Step 4: Return the serialized data
    return serialized_plants


def extract_json_data(data):
    # Find the start and end indices of the JSON array
    start_index = data.find('[')
    end_index = data.rfind(']')

    # Extract the JSON substring
    if start_index != -1 and end_index != -1:
        json_data = data[start_index:end_index + 1]
        return json_data
    else:
        return None