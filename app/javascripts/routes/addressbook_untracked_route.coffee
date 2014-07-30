Radium.AddressbookUntrackedRoute = Radium.Route.extend
  model: ->
    @dataset = Radium.InfiniteDataset.create
      type: Radium.Contact
      params: {private: true}
  actions:
    track: (contact) ->
      if confirm "Track this contact in Radium?"
        track = Radium.TrackedContact.createRecord
                  contact: contact

        track.one 'didCreate', (result) =>
          @send "flashSuccess", "Contact is now tracked in Radium"
          @dataset.removeObject(contact)

        @store.commit()

    loadMoreContacts: ->
      @dataset.expand()

    destroyContact: (contact)->
      if confirm "delete this contact?"
        contact.deleteRecord()
        contact.one 'didDelete', =>
          @send "flashSuccess", "Contact deleted"
          @dataset.removeObject contact
        @store.commit()