from django.db import models

from core import settings


class Plant(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    plant_index = models.CharField(max_length=20)
    name = models.CharField(max_length=100)
    planting_date = models.DateField()
    location_lat = models.CharField(max_length=100)
    location_long = models.CharField(max_length=100)
    water_require = models.CharField(max_length=10)
    last_watering = models.DateTimeField(blank=True,null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name



class RecommendedPlants(models.Model):
    name = models.CharField(max_length=100)
    category = models.CharField(max_length=100)
    bestgrow = models.CharField(max_length=100)
    img = models.CharField(max_length=100)
    date = models.CharField(max_length=50,blank=True,null=True)
    address = models.CharField(max_length=100,blank=True,null=True)
    water_time = models.CharField(max_length=100,blank=True,null=True)


