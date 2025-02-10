from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent.parent.parent
# file1_model1 = BASE_DIR / 'src/ai/ai_models/model1/k_clustering.pkl'


import pandas as pd


class Alert:
    """"" This class is Handling 
            1.Get Alerts 
            2.Update Alerts 
            3.Create Alerts"""""

    def __init__(self, seed_id=None):
        self.seed_id = seed_id

        # Files Path

        self.heat_cluster = BASE_DIR / 'src/ai/ai_models/alerts/heat/heat_cluster.pkl'
        self.wind_cluster = BASE_DIR / 'src/ai/ai_models/alerts/wind/wind_cluster.pkl'
        self.rain_cluster = BASE_DIR / 'src/ai/ai_models/alerts/rain/rain_cluster.pkl'

    def predict_heat_alert(self, temp):
        """This method is for Getting
         Alert Of heat on the base of
        provided temperature in specific location for Seed_ID """

        data = pd.read_pickle(self.heat_cluster)
        stage = None

        filtered_data = data[(data['Seed_ID'] == self.seed_id) & (data['Heat_Wave'] < temp)]

        if not filtered_data.empty:
            _temp = filtered_data['Heat_Wave'].iloc[0]
            stage = temp - _temp
        return stage

    # Predict Wind Alerts

    def predict_wind_alert(self, wind):
        """This method is for Getting
         Alert Of Wind on the base of
        provided Wind in specific location for Seed_ID """
        stage = None
        data = pd.read_pickle(self.wind_cluster)

        filtered_data = data[(data['Seed_ID'] == self.seed_id) & (data['Wind'] < wind)]

        if not filtered_data.empty:
            _wind = filtered_data['Wind'].iloc[0]
            stage = wind - _wind
        return stage

    # Predict Rain Alerts

    def predict_rain_alert(self, rain):
        """This method is for Getting
         Rain Of heat on the base of
        provided Rain in specific location for Seed_ID """

        data = pd.read_pickle(self.rain_cluster)
        stage = None
        filtered_data = data[(data['Seed_ID'] == self.seed_id) & (data['Rainfall'] < rain)]

        if not filtered_data.empty:
            _rain = filtered_data['Rainfall'].iloc[0]
            stage = rain - _rain
        return stage

    # Update Heat Wave Alert Value

    def update_heat_alert(self, new_heat):
        """This method is for
        Updating Heat Threshold
        Value Max Value against Specific Provided Seed_ID"""

        data = pd.read_pickle(self.heat_cluster)
        if self.seed_id in data['Seed_ID'].values:
            data.loc[data['Seed_ID'] == self.seed_id, 'Heat_Wave'] = new_heat
            data.to_pickle(self.heat_cluster)
            return f"Heat Updated Successfully for Seed_ID {self.seed_id}"
        else:
            return f"Seed_id {self.seed_id} does not exist in Data"

    def update_wind_alert(self, wind):
        """This method is for
        Updating Heat Threshold
        Value Max Value against Specific Provided Seed_ID"""

        data = pd.read_pickle(self.wind_cluster)
        if self.seed_id in data['Seed_ID'].values:
            data.loc[data['Seed_ID'] == self.seed_id, 'Wind'] = wind
            data.to_pickle(self.wind_cluster)
            return f"Wind Updated Successfully for Seed_ID {self.seed_id}"
        else:
            return f"Seed_ID {self.seed_id} does not exist in Data"

    def update_rain_alert(self, rain):
        """This method is for
        Updating Heat Threshold
        Value Max Value against Specific Provided Seed_ID"""

        data = pd.read_pickle(self.rain_cluster)
        if self.seed_id in data['Seed_ID'].values:
            data.loc[data['Seed_ID'] == self.seed_id, 'Rainfall'] = rain
            data.to_pickle(self.rain_cluster)
            return f"Rainfall Updated Successfully for Seed_ID {self.seed_id}"
        else:
            return f"Seed_id {self.seed_id} does not exist in Data"








# TODO: Still Not Sure that how it will work





    def add_new_data_heat_alert(self, heat):
        data = pd.read_pickle(self.heat_cluster)
        max_seed_id = data['Seed_ID'].max()
        new_seed_id = None
        if self.seed_id is not None:
            if self.seed_id in data['Seed_ID']:
                return f"Already Exist Seed ID {self.seed_id}"
            else:
                new_seed_id = self.seed_id
        else:
            new_seed_id = max_seed_id + 1 if not pd.isnull(max_seed_id) else 1
        new_row = pd.DataFrame({'Seed_ID': [new_seed_id], 'Heat_Wave': [heat]})
        data = data.append(new_row, ignore_index=True)
        data.to_pickle(self.heat_cluster)

        return f"New row added successfully with seed_id {new_seed_id} and heat {heat}"

    def add_new_data_wind_alert(self, wind):
        data = pd.read_pickle(self.wind_cluster)

        max_seed_id = data['Seed_ID'].max()
        new_seed_id = max_seed_id + 1 if not pd.isnull(max_seed_id) else 1
        new_seed_id = None
        if self.seed_id is not None:
            if self.seed_id in data['Seed_ID']:
                return f"Already Exist Seed ID {self.seed_id}"
            else:
                new_seed_id = self.seed_id
        else:
            new_seed_id = max_seed_id + 1 if not pd.isnull(max_seed_id) else 1
        new_row = pd.DataFrame({'Seed_ID': [new_seed_id], 'Wind': [wind]})
        data = data.append(new_row, ignore_index=True)
        data.to_pickle(self.wind_cluster)
        return f"New row added successfully with seed_id {new_seed_id} and wind {wind}"

    def add_new_data_rain_alert(self, rain):
        data = pd.read_pickle(self.rain_cluster)

        max_seed_id = data['Seed_ID'].max()
        new_seed_id = max_seed_id + 1 if not pd.isnull(max_seed_id) else 1
        new_seed_id = None
        if self.seed_id is not None:
            if self.seed_id in data['Seed_ID']:
                return f"Already Exist Seed ID {self.seed_id}"
            else:
                new_seed_id = self.seed_id
        else:
            new_seed_id = max_seed_id + 1 if not pd.isnull(max_seed_id) else 1
        new_row = pd.DataFrame({'Seed_ID': [new_seed_id], 'Heat_Wave': [rain]})
        data = data.append(new_row, ignore_index=True)
        data.to_pickle(self.rain_cluster)
        return f"New row added successfully with seed_id {new_seed_id} and rain {rain}"
