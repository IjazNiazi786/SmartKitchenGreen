from rest_framework import  serializers

from src.apis.garden.models import Plant


class PlantSerializer(serializers.ModelSerializer):
    class Meta:
        model = Plant
        fields='__all__'
        read_only_fields = ['id', 'created_at', 'updated_at']

