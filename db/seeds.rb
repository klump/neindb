# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create([
  { name: 'Administrator', username: 'admin', email: 'email@example.com', password: 'password', password_confirmation: 'password', role: 'admin' },
])

Asset::Computer.create([
  { name: '', properties: {
    product_name: "Product name",
    bios_version: "1a",
    bios_vendor: "Some",
    location: "Desk",
    pci_slots: 1,
    dimm_slots: 2}
  }
])
