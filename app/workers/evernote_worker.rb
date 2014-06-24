class EvernoteWorker
  include Sidekiq::Worker
  sidekiq_options queue: "external_api"

  def perform date, user_id
    user = User.find(user_id)
    client = create_client_for user
    updated_notes = user_notes_updated_on date, client
    created_notes = user_notes_created_on date, client
    updated_notes = updated_notes - created_notes
    save_notes_created_on date, created_notes, user_id
    save_notes_updated_on date, updated_notes, user_id
  end

  def user_notes_created_on date, client
    notes = client.note_store.findNotes(Evernote::EDAM::NoteStore::NoteFilter.new, 0, 100).notes
    notes.select { |note| Time.at(note.created.to_s[0..-4].to_i).to_s[0..9] == date.to_s[0..9] }
  end

  def user_notes_updated_on date, client
    notes = client.note_store.findNotes(Evernote::EDAM::NoteStore::NoteFilter.new, 0, 100).notes
    notes.select { |note| Time.at(note.updated.to_s[0..-4].to_i).to_s[0..9] == date.to_s[0..9] }
  end

  def create_client_for user
    client = EvernoteOAuth::Client.new(consumer_key: ENV['EVERNOTE_CONSUMER_KEY'],
                                       consumer_secret: ENV['EVERNOTE_CONSUMER_SECRET'],
                                       sandbox:true)
    token = user.evernote_accounts.first.token
    client = EvernoteOAuth::Client.new(token: token)
  end

  def save_notes_created_on date, notes, user_id
    notes.each do |note|
      unless EvernoteEntry.exists?(note_id: note.guid)
        EvernoteEntry.create(user_id: user_id,
                             date: date.to_s[0..9],
                             note_id: note.guid,
                             kind: "created",
                             title: note.title)
      end
    end
  end

  def save_notes_updated_on date, notes, user_id
    notes.each do |note|
      unless EvernoteEntry.exists?(note_id: note.guid)
        EvernoteEntry.create(user_id: user_id,
                             date: date.to_s[0..9],
                             note_id: note.guid,
                             kind: "updated",
                             title: note.title)
      end
    end
  end
end