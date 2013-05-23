Factory.define 'company', traits: 'timestamps',
  name: -> Dictionaries.companies.random()
  address: -> Factory.create 'address'
  website: -> "#{@name.replace(/\s/, '-')}.com".toLowerCase()
  status: -> Dictionaries.leadStatuses.random()

  addresses: -> [
    Factory.create 'address',
      name: 'Office'
      isPrimary: true
  ]

  about: -> "Information about #{@name}"
