# OneShip Customer

# Project rules

1. icon: 
    - Folder: assets/icons/
    - Naming format: ic_xxx
    - Extension: svg
2. image:
    - Folder: assets/images/
    - Extension: png, jpg, gif, ...

# Login and test FCM

gcloud auth application-default login
gcloud auth application-default print-access-token

# Generate code

flutter pub run build_runner build --delete-conflicting-outputs
