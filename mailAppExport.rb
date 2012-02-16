#!/opt/local/bin/ruby
require 'rubygems'
require 'appscript'

# Also requires mutt-devel with imap, smtp, trash, ssl
# TODO: should we check mutt's available options? is it not our problem?
# TODO: should the user be prompted for anything?
# TODO: instead of only exporting, what if it was a full configurator?
# TODO: what if it had an NCurses menu interface? so you could set it up like any other?
# What about muttrc builder? it doesn't do hooks, or multi-account setups, and it's on the web

class MuttConfigutor
    # configuration file
    # options
    #
    # export configuration from mac mail
    #   accounts
    #   folder preferences?
    # import configuration into mac mail (some restrictions may apply) [autoconfiguring email!]
    # make changes to an existing config?
    # make a new config
    # save config
end

class MuttConfig
    # accounts info (array)
    #   username
    #   password (not saved or written, it needs to go to and from keychain)
    #   account type
    #   account name
    #   incoming server info (ssl? server name, protocol, connect string?)
    #   outgoing server info (same)
    #   write muttrc header
    #   write mailboxes line
    # build URL (is ssl enabled? what protocol? user? pass? folder? domain?)
end

class AccountHook
    #   set user (imap_user)
    #   set pass (imap_pass)
    # imap_user or pop_user, depending on account type
    attr_accessor :user
    #   write/print account hook
end

class FolderHook
    #   write/print folder hook
    #   set hook name
    #   set push line
    #   set spoolfile
    #   set from
    #   set envelope_from
    #   set record
    #   set postponed
    #   set outgoing info (smtp url, smtp_pass)
end

# Access Mail.app
all_accounts = Appscript.app("Mail").accounts.get

=begin
    account-hook imaps://$my_etsy_server_string ' \
        set imap_user="mhernandez@etsy.com"; \
        set imap_pass=`security find-internet-password -g \
            -s imap.gmail.com 2>&1 >/dev/null | cut -d\" -f2`'
    mailboxes imaps://mhernandez@etsy.com@imap.gmail.com/INBOX

#  this hook also uses a custom variable since the username isn't the email
    folder-hook imaps://mhernandez@etsy.com@imap.gmail.com/INBOX ' \
        push "<change-folder>?<change-dir><kill-line>imaps://mhernandez@etsy.com@imap.gmail.com/<Enter><exit>"; \
        set spoolfile="imaps://mhernandez@imap.gmail.com/INBOX" \
        set from="mhernandez@etsy.com"; \
        set use_from; \
        set envelope_from; \
        set record="imaps://mhernandez@imap.gmail.com/[Gmail]/Sent Mail"; \
        set postponed="imaps://mhernandez@imap.gmail.com/[Gmail]/Drafts"; \
        set smtp_url="smtps://mhernandez@etsy.com@smtp.gmail.com"; \
        set smtp_pass=`security find-internet-password -g \
            -s smtp.gmail.com 2>&1 >/dev/null | cut -d\" -f2`'
=end


# loop through all of the accounts,
all_accounts.each { |account|
    if account.enabled
        # this can be used in a comment in the mutt file
        print "# Account: #{account.name.get} \n"

        print "#{account.full_name.get} is the full name\n"

        # works if one address per acct?
        print "#{account.email_addresses.get} is the address\n"

        # if it's imap, great. If it's pop we need to try exporting the mail and more (yikes)
        print "#{account.account_type.get} is the account type\n"

        # incoming server name
        print "#{account.server_name.get} is the incoming server name\n"

        # does it use ssl?
        if account.uses_ssl
            print "#{account.server_name.get} uses SSL to connect\n"
        end

        print "#{account.user_name.get} is the username\n"
        # the password comes from the keychain
        # where username is mhernandez@etsy.com or whatever else
        # security find-internet-password -g -a mhernandez@etsy.com 2>&1 >/dev/null | cut -d\"

        print "#{account.delivery_account.get} is the outgoing account\n"

    end
}
