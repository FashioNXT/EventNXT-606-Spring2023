class Guest < ApplicationRecord
  belongs_to :event
  belongs_to :user, foreign_key: :added_by

  has_many :guest_seat_tickets, dependent: :destroy
  has_many :guest_referrals, dependent: :destroy
  has_many :guest_referral_rewards, dependent: :destroy
  has_many :seats, through: :guest_seat_tickets, dependent: :destroy
  has_many :referral_rewards, through: :guest_referral_rewards, dependent: :destroy

  attribute :booked, :boolean, default: false
  attribute :checked, :boolean, default: false

  validates :email, presence: true, uniqueness: { scope: :event }
  validates :booked, inclusion: [true, false, nil]
  validates :added_by, presence: true
  validates :referral_expiration, expiration: true
  validate :checked_only_if_booked
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: { scope: :event_id }
  #validates :seat_level, presence: true

 def self.new_guest(attributes = {})
    puts "Creating guest with data: first_name=#{attributes[:first_name]}, last_name=#{attributes[:last_name]}, email=#{attributes[:email]}, event_id=#{attributes[:event_id]}"
    guest = Guest.new(attributes) #creates new guest
    
    
    guest#return guest
  end
  
  def checked_only_if_booked
    return if (booked || !checked)
    errors.add(:checked, "can't be true if guest hasn't booked")
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  #def self.to_csv
  #  guests = all
  #  CSV.generate(headers: true) do |csv|
  #    cols = [:last_name, :first_name, :email, :added_by, :affiliation, :perks, :comments, :type,
  #        :booked, :invited_at, :invite_expiration, :referral_expiration]
  #    csv << cols
  #    guests.each do |guest|
  #      user_email = guest.user.email
  #      gattr = guest.attributes.symbolize_keys.to_h
  #      gattr[:added_by] = guest.user.email
  #      gattr[:booked] = gattr[:booked] ? 'X' : ''
  #      csv << gattr.values_at(*cols)
  #    end
  #  end
  #end
  
  def self.to_csv
    guests = all
    CSV.generate(headers: true) do |csv|
      cols = [:first_name, :last_name, :email, :affiliation, :perks, :comments, 
               :seat_category, :allotted, :committed, :guestcommitted, :status, :added_by]
      csv << cols
      guests.each do |guest|
        if guest.guest_seat_tickets.empty?
          csv << [guest.first_name, guest.last_name, guest.email, guest.affiliation, guest.perks, guest.comments, '', '', '', '', '', guest.user.email]
          next
        end
      
        guest.guest_seat_tickets.each do |ticket|
          user_email = guest.user.email
          gattr = guest.attributes.symbolize_keys.to_h
          gattr[:added_by] = guest.user.email
          gattr[:status] = guest.booked ? 'X' : ''
          gattr[:seat_category] = ticket.seat.category
          gattr[:allotted] = ticket.allotted
          gattr[:committed] = ticket.committed
          
          csv << gattr.values_at(*cols)
        end
      end
    end
  end
  
  def self.import_guests_csv(file, event)
    CSV.foreach(file.path, headers: true, header_converters: :symbol, converters: :all) do |row|
      first_name = row[:first_name]
      last_name = row[:last_name]
      email = row[:email]
      
      event_id = event.id
      added_by = event.user.id
      
      # Try to find an existing guest with the same email
      guest = Guest.find_or_initialize_by(email: email, event_id: event_id)
      if guest.new_record?
        # Guest.create!(first_name: first_name, last_name: last_name, email: email, added_by: added_by, event_id: event_id)
        guest.first_name = first_name
        guest.last_name = last_name
        guest.email = email
        guest.added_by = added_by
        guest.event_id = event_id
        guest.save!
      end

      
    end
  end

  after_create :generate_qr_code

  def generate_qr_code
    Rails.logger.info "Generating QR code for guest #{self.id}"
    self.qr_code = QrCodeService.generate_qr_code(self)
    self.qr_code_png = QrCodeService.generate_qr_code_png(self)

    save
    Rails.logger.info "QR code and QR code PNG generated for guest #{self.id}"
  end
end
