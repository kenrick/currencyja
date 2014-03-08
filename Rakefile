require "./currencyja"
require "sinatra/activerecord/rake"
require "pry"


task :update_traders  do |t|

  Forex::Trader.all.each do |trader, klass|
    begin
        trader = Trader.where(name: klass.name, short_name: trader).first_or_create
        fetch_currencies = klass.fetch
        unless fetch_currencies.empty?
            Cambio.where(name: klass.name).first_or_create.update_attributes(currencies: fetch_currencies)
            puts "Updated #{trader}"

            %w{ USD EUR CAD GBP }.each do |note|

                unless note == "EUR" && trader.short_name == "FXTRADERS"
                    note_rates = fetch_currencies[note]
                else
                    note_rates = fetch_currencies["EURO"]
                end

                note_rates[:note] = note.downcase
                note_rates.each{ |key,val| note_rates[key] = val ? val.to_s : nil }

                original = trader.currencies.where(note_rates).last
                unless original
                    current = trader.currencies.build(note_rates)

                    if trader.currencies.where(note: note.downcase).any?
                        original = trader.currencies.where(note: note.downcase).last
                        changed_rates(original, current) do |rate|
                            twitter_client.update build_tweet_string(original, current, rate)
                        end
                    end

                    current.save!
                end
            end


        end
    rescue Exception => e
        # puts "Failed to Parse #{trader} because of #{e}"
        raise e
    end
  end
end

task :console do
    binding.pry
end

def changed_rates(original, current, &block)
    changed = []
    rate_names = [:buy_cash, :buy_draft, :sell_cash, :sell_draft]
    original.attributes.each do |a , _|
        attribute = a.to_sym
        if rate_names.include?(attribute)
            a, b = original.send(attribute), current.send(attribute)
            changed << attribute if a != b
        end
    end

    changed.each { |c| block.call c }
end

def build_tweet_string(original, current, rate)
    "#{original.trader.name} has change thier #{original.note.upcase} #{rate} from #{original.send(rate)} rate to #{current.send(rate)}"
end

def twitter_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = "mDlDbEyWnkOBBzBRiPJVw"
      config.consumer_secret     = "7rzKVqQK40kYVd3q9WLqYH1FMvHbz9lye6VdewdSfAY"
      config.access_token        = "2377914818-tywmSZV1wH82WWqIyVcRgRXa5yYinqnFd4Lelok"
      config.access_token_secret = "OEjheyeL7EfFJCOLI0E9hIa1vVUY8uuSQKVGJbFmiVInt"
    end
end
