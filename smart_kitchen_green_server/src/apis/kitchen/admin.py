# In products/admin.py

from django.contrib import admin
from src.apis.kitchen.models import (Product , Appliance)


@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ('name', 'quantity', 'expiry_date', 'type', 'appliance_time', 'user')
    search_fields = ('name',)
    list_filter = ('expiry_date', 'created_at', 'type')
    ordering = ('-created_at',)


@admin.register(Appliance)
class ApplianceAdmin(admin.ModelAdmin):
    list_display = ('name', 'type', 'can_cool', 'can_heat', 'user')
    search_fields = ('name',)
    list_filter = ('type', 'can_cool', 'can_heat', 'created_at')
    ordering = ('-created_at',)
