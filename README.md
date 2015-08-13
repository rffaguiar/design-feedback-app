# README

Welcome to the design feedback app. This is a simple feedback tool heavily inspired by redpen.io

## How it Works
An User create an account and can upload some images

Each image generates an unique link

Image owners can share their images through these links

Only registered users can see/comment on images

When an user comments, the image owner receives an email.

## Demo
**attention:** the demo app is in portuguese-BR

Check the [demo app](http://designfeedback.com.br)

## System Requirements

* ruby >= 2.1
* rails >= 4.1
* rmagick

## Setup

1. git clone git@github.com:rffaguiar/design-feedback-app.git
2. cd design-feedback-app
3. bundle install
4. rake db:setup
5. rails s
6. go to [localhost:3000](http://localhost:3000/)

## Dependencies

1. Devise: for sign up & sign in
2. kaminari: for pagination
3. recaptcha: for contact form
4. rmagick: for image manipulations like thumbnails and redimensions

## Configuration
### Google analytics
Default: disabled

If you are going to use this on production, you can put your Google analytics stuff in **app/assets/javascripts/ga.js**. It's being added at the top of application.html.erb and singles.html.erb layouts. To enabled it, just insert your GA code on this file.

### Recaptcha
Default: disabled

Recaptcha is a better version of the famous captcha (and those annoying numbers and letters). With recaptcha the user just 'click', yes, just 'click' and it works. Probably magic. Recaptcha is used only in contact form

### Admin Panel
**This admin panel is very basic**. To have access to the admin panel (localhost:3000/admin), you should create an admin user using the **rails console**.

1. Go to app root and run `rails c`
2. `Admin.create name: 'Admin Name', email: 'admin.email@gmail.com', password: 'notmybirthday', password_confirmation: 'notmybirthday'`
3. Run `Admin.last` just to check if everything is fine and the new admin is there
4. Go to [localhost:3000/admin](http://localhost:3000/admin) and log in

## To be done

* Feedback form exists, but its hidden for a while
* E2E tests
* JS tests

### Media used

Patterns from [Subtle Patterns](http://subtlepatterns.com/)

Images from [Gratisography](http://www.gratisography.com/)
