#Define the routes for our backend applicationfrom django.contrib import admin

from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('prediction.urls')),
]
