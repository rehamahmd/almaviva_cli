# Flutter Cli for Almaviva 

A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.



# First Setup
compile => dart compile exe bin/almaviva_cli.dart -o alma
create_file => sudo chmod +x /usr/local/bin/alma
move_file => sudo mv alma /usr/local/bin/
- nano ~/.zshrc
- export PATH="$PATH:$HOME/.pub-cache/bin"
- source ~/.zshrc


dart pub global activate --source path .
# almaviva_cli
