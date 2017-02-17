Let's switch to redeemify
cd ..
cd redeemify I am

I propose to create a separate branch for our task
git branch import / git checkout import   

The overall goal is to eliminate duplication code in controllers
Open providers_controller.rb and vendors_controller.rb

Inspect them attentively

Four methods have the same functions:
    home
    import
    remove_unclaimed_codes
    clear_history

The difference in paths for redirection and in offeror (provider or vendor)

The general idea is to move these methods into module, and then include this
module in both controllers

To make this possible we have to generalize these methods.

Freddy, are you here?  yes, I was trying to inspect where those four methods have the
same functions, but I didn't really see

Good! Let me make a brief introduction in the app
We have two kinds of offerors (providers and vendors)
Both can upload codes and manage them
The interfaces for both are almost the same
All the functions (uploading of codes (import), removing of codes (remove_unclaimed_codes),
removing the history of actions (clear_history)) are the same, but they
defined for both offerors separately                                   Ok, I see
So, Both Controllers, Prov&Vendors have these same functions impletmented, just the
routes that differ
Yes. Routes and offerors (provider or vendor)

Now when we understand it, we can move all these methods into new module and
make them (methods) general by replacement of moving parts on general construction
depending on the controller  Ok

There is practice to use concerns
You can read this blog post later: ok, will it explain me why we've created that concern folder?
    https://signalvnoise.com/posts/3372-put-chubby-models-on-a-diet-with-concerns

In new versions of Rails it is created by default. with concerns as name? ok, I'll read

You've copied import method in concerns/import.rb
Good! Let's switch to this file   ok


