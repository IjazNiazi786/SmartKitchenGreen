from rest_framework import viewsets
from rest_framework.permissions import AllowAny

from src.apis.garden.serializers import PlantSerializer
from src.apis.garden.models import Plant


# RECOMMENDATION NEED
from rest_framework import status
from rest_framework.generics import CreateAPIView
from rest_framework.response import Response
from rest_framework.views import APIView

from src.apis.garden.recommendation.ai_models.recommend_content_based import Prediction
from src.external.weather.main import get_weather_data



class PlantApiView(viewsets.ModelViewSet):

    queryset = Plant.objects.all()
    serializer_class = PlantSerializer
    permission_classes = [AllowAny]





# VERIFIED
class ProductRecommendationOnLocationAPI(APIView):

    def get(self, request, *args, **kwargs):
        latitude = self.kwargs.get('latitude')
        longitude = self.kwargs.get('longitude')
        address = self.kwargs.get('address')
        is_more = self.kwargs.get('is_more')
        is_more = bool(is_more)



        try:
            # CONVERT TO FLOAT -- ISSUE HERE
            latitude = float(latitude)
            longitude = float(longitude)

            (temperature, humidity, soil_temperature_0_to_7cm, soil_moisture_0_to_7cm, precipitation, daylight_duration) \
                = get_weather_data(latitude, longitude)

            input_data = {
                'Temperature': temperature,
                'Soil_Temperature': soil_temperature_0_to_7cm,
                'Soil_Moisture': soil_moisture_0_to_7cm,
                'Precipitation': precipitation,
                'Sunshine_Duration': daylight_duration,
                'Humid': humidity
            }

            # TODO: AI: IK
            prediction = Prediction(data=input_data,address=address,is_more=is_more)

            return Response(data=prediction.filter_predictions())

        except Exception as e:
            return Response(data={'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

