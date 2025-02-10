from src.apis.garden.models import Plant, RecommendedPlants
from django.contrib import admin


@admin.register(Plant)
class PlantAdmin(admin.ModelAdmin):
    list_display = ('name', 'planting_date', 'user')
    search_fields = ('name', 'user')
    list_filter = ('name', 'user', 'planting_date', 'created_at')
    ordering = ('-created_at',)


@admin.register(RecommendedPlants)
class RecommendedPlantsAdmin(admin.ModelAdmin):
    list_display = ('name','category','date','address')
    search_fields = ('name','category','date','address')
    list_filter = ('name','category','date','address')

