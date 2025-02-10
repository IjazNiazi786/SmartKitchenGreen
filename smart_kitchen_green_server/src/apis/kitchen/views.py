from rest_framework import viewsets, status
from rest_framework.permissions import AllowAny , IsAuthenticated
from rest_framework.response import Response

from src.apis.kitchen.serializers import ProductSerializer ,ApplianceSerializer
from src.apis.kitchen.models import Product,Appliance


class ProductApiView(viewsets.ModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        return Product.objects.filter(user=user)

    def create(self, request, *args, **kwargs):
        user = request.user
        data = request.data

        if isinstance(data, list):
            # Handling multiple product creation
            serializers = [self.get_serializer(data=item) for item in data]
            for serializer in serializers:
                serializer.is_valid(raise_exception=True)
                serializer.save(user=user)
            return Response([serializer.data for serializer in serializers], status=status.HTTP_201_CREATED)
        else:
            # Handling single product creation
            serializer = self.get_serializer(data=data)
            serializer.is_valid(raise_exception=True)
            serializer.save(user=user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)








class ApplianceApiView(viewsets.ModelViewSet):
    queryset = Appliance.objects.all()
    serializer_class = ApplianceSerializer
    permission_classes = [AllowAny]
