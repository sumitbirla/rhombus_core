r1 = Role.create(name: 'Administrator', default: false, super_user: true)
r2 = Role.create(name: 'Customer', default: true, super_user: false)

admin = User.create( name: 'Admin User', email: 'admin@example.com', role_id: r1.id, password_digest: BCrypt::Password.create('password'))

Setting.create(section: 'system', key: 'Website Name', value: 'Some Website', value_type: 'string')
Setting.create(section: 'system', key: 'Website URL', value: 'http://localhost', value_type: 'string')
Setting.create(section: 'system', key: 'Time Zone', value: 'Eastern Time (US & Canada)', value_type: 'string')
Setting.create(section: 'system', key: 'From Email Address', value: 'admin@example.com', value_type: 'string')
Setting.create(section: 'system', key: 'From Email Name', value: 'Example Admin', value_type: 'string')
Setting.create(section: 'system', key: 'SMTP Server', value: '127.0.0.1', value_type: 'string')
Setting.create(section: 'system', key: 'Facebook App ID', value: 'xxxxxxxxxx', value_type: 'string')
Setting.create(section: 'system', key: 'Facebook App Secret', value: 'xxxxxxxxxx', value_type: 'string')

Permission.create(section: 'system', resource: 'admin', action: 'login')

Permission.create(section: 'system', resource: 'user', action: 'read')
Permission.create(section: 'system', resource: 'user', action: 'create')
Permission.create(section: 'system', resource: 'user', action: 'update')
Permission.create(section: 'system', resource: 'user', action: 'destroy')
Permission.create(section: 'system', resource: 'user', action: 'reset_password')

Permission.create(section: 'system', resource: 'role', action: 'read')
Permission.create(section: 'system', resource: 'role', action: 'create')
Permission.create(section: 'system', resource: 'role', action: 'update')
Permission.create(section: 'system', resource: 'role', action: 'destroy')

Permission.create(section: 'system', resource: 'notification', action: 'read')
Permission.create(section: 'system', resource: 'notification', action: 'create')
Permission.create(section: 'system', resource: 'notification', action: 'update')
Permission.create(section: 'system', resource: 'notification', action: 'destroy')

Permission.create(section: 'system', resource: 'setting', action: 'read')
Permission.create(section: 'system', resource: 'setting', action: 'create')
Permission.create(section: 'system', resource: 'setting', action: 'update')
Permission.create(section: 'system', resource: 'setting', action: 'destroy')

Permission.create(section: 'system', resource: 'affiliate', action: 'read')
Permission.create(section: 'system', resource: 'affiliate', action: 'create')
Permission.create(section: 'system', resource: 'affiliate', action: 'update')
Permission.create(section: 'system', resource: 'affiliate', action: 'destroy')

Permission.create(section: 'system', resource: 'login', action: 'read')
