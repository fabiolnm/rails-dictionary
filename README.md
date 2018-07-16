# Rails Dictionary

Simple tool to read locale yml files and present them in a matrix UI.
When a key is edited, it's written back to the YML files:

![Example](https://raw.githubusercontent.com/fabiolnm/rails-dictionary/7137d1c454f0405a9f990aafb2724fca833a514e/public/example.png)

## How to use

1. Clone this repository
2. `rake db:setup`
3. `rails s` (It will start a new rails application at http://localhost:3333)
4. New App
5. Path: full path to a Rails project
6. `config/locales/app.yml`, `config/locales/app.pt-BR.yml` will be grouped
as a single entry.
7. When you click it, a matrix of translations will be displayed.
