#Define the routes for our backend applicationfrom django.contrib import admin

from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('prediction.urls')),
]


from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/auth/', include('users.urls')),
    path('api/', include('prediction.urls')),
]

from django.urls import path, include

from users.views import APILoginView, APILogoutView
urlpatterns = [
    path('login/', APILoginView.as_view(), name='api_login'),
    path('logout/', APILogoutView.as_view(), name='api_logout'),
]
