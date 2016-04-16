## Getting Started with Rhombus

### Create a new Rails app
  rails new `app_name` -T --skip-sprockets

### Modify Gemfile to include rhombus engines as needed

> gem 'rhombus_core', git: 'https://github.com/sumitbirla/rhombus_core' <br>
> gem 'rhombus_cms', git: 'https://github.com/sumitbirla/rhombus_cms' <br>
> gem 'rhombus_billing', git: 'https://github.com/sumitbirla/rhombus_billing' <br>
> gem 'rhombus_store', git: 'https://github.com/sumitbirla/rhombus_store' <br>
> gem 'rhombus_marketing', git: 'https://github.com/sumitbirla/rhombus_marketing' <br>
> gem 'rhombus_ticketing', git: 'https://github.com/sumitbirla/rhombus_ticketing' <br>
> gem 'rhombus_pbx', git: 'https://github.com/sumitbirla/rhombus_pbx'

### Configure rails app
Add the following to `config/application.rb`
> config.domain_id = 1 <br>
> config.modules = [:billing, :cms, :pbx, :store, :ticketing, :marketing]

### Set up database

1. Create database
2. Create a user and give permission to above database
3. Modify config/database.yml accordingly
4. run `rake db:migrate`
5. Add the following to db/seeds.rb (add lines corresponding to the gems)
> RhombusCore::Engine.load_seed <br>
> RhombusCms::Engine.load_seed  <br>
> RhombusBilling::Engine.load_seed  <br>
> RhombusMarketing::Engine.load_seed  <br>
> RhombusTicketing::Engine.load_seed  <br>
> RhombusPbx::Engine.load_seed <br>
> RhombusStore::Engine.load_seed <br>
6. Run `rake db:seed`

### Run it

> rails s <br>
> Open http://localhost:3000/admin <br> 
> Log in as admin@example.com / password <br>


