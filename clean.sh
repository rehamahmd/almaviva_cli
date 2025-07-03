# # 1. Set up FVM path


# #!/bin/bash

# echo "🚀 Starting project preparation..."

# # 1. Clean project
# echo "🧹 Cleaning project..."
#  flutter clean || { echo "❌ Clean failed"; exit 1; }

# await 
# # 2. Get dependencies
# echo "📦 Getting dependencies..."
#  flutter pub get || { echo "❌ Pub get failed"; exit 1; }
# await
# # 3. Run build_runner
# echo "🏗️  Running build_runner..."
#  flutter packages pub run build_runner build --delete-conflicting-outputs || { echo "❌ Build runner failed"; exit 1; }
# await
# # 4. Generate localization files
# echo "🌍 Generating localization files..."
#  flutter pub run easy_localization:generate -S assets/translations -f keys -O lib/src/core/l10n -o locale_keys.g.dart || { echo "❌ Localization generation failed"; exit 1; }

# echo "✅ Project preparation completed successfully!"