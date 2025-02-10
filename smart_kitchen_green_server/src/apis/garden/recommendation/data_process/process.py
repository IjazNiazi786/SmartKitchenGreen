import pandas as pd

# weights = {'Temperature_Average': 4,
#            'Soil Temperature__min': 4,
#            'Soil_Moisture_Average_divided': 100,
#            'Evapotranspiration_Average': 2, 'Sunshine_Duration_Average': 0.5}
#


class WeighDecorator:
    def __init__(self,data):
        self.temp = data['Temperature']
        self.soil_temp = data['Soil_Temperature']
        self.soil_moist = data['Soil_Moisture']
        self.evp = data['Precipitation']
        self.sunshine = data["Sunshine_Duration"]
        self.humidity = data["Humid"]

    def decorated_temp(self):
        return self.temp * 1

    def decorated_soil_temp(self):
        return self.soil_temp * 1

    def decorated_soil_moist(self):
        return self.soil_moist * 1

    def decorated_evp(self):
        return self.evp * 1

    def decorated_sun_light(self):
        return self.sunshine * 0.00

    def decorated_humidity(self):
        return self.humidity*0.5





def get_processed_data(data):

    decorator = WeighDecorator(data)

    new_data = pd.DataFrame({
        'Temperature': [decorator.decorated_temp()],
        'Soil_Temperature': [decorator.decorated_soil_temp()],
        'Precipitation': [decorator.decorated_evp()],
        'Soil_Moisture': [decorator.decorated_soil_moist()],
        'Sunshine_Duration': [decorator.decorated_sun_light()],
        'Humid': [decorator.decorated_humidity()]
    })

    return new_data