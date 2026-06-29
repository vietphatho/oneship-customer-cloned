# OzoShip Seller

Flutter: 3.38.2

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
dart run build_runner build --delete-conflicting-outputs

# Build apk release

1. dev enviroment

flutter build apk \
  --release \
  --dart-define=FLAVOR=dev \
  --split-per-abi \
  --obfuscate \
  --split-debug-info=build/debug-info \
  --tree-shake-icons \
  -PFLAVOR=dev

2. production enviroment

flutter build apk \
  --release \
  --dart-define=FLAVOR=prod \
  --split-per-abi \
  --obfuscate \
  --split-debug-info=build/debug-info \
  --tree-shake-icons \
  -PFLAVOR=prod

# build aab

flutter build appbundle --release

flutter build apk \
  --release \
  --split-per-abi \
  --obfuscate \
  --split-debug-info=build/debug-info \
  --tree-shake-icons