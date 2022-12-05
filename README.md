# 🍻 Ozei

A modern restaurant reservation system for last-minute requests on mobile.

![image](https://user-images.githubusercontent.com/66011769/205541912-3bdb7e66-f6e7-4dcd-b1f8-94477bc0e41b.png)
![image](https://user-images.githubusercontent.com/66011769/205541886-e80a108a-7797-402b-bb19-ba70332ae911.png)

<br>
App home: https://www.ozei.fun
   

## Getting Started
### Setup

Install gems
```
bundle install
```
Install JS packages
```
yarn install
```

### ENV Variables
Create `.env` file
```
touch .env
```
Inside `.env`, set these variables. For any APIs, see group Slack channel.
```
CLOUDINARY_URL=your_own_cloudinary_url_key
```

### DB Setup
```
rails db:create
rails db:migrate
rails db:seed
```

### Run a server
```
rails s
```

## Built With
- [Rails 7](https://guides.rubyonrails.org/) - Backend / Front-end
- [Stimulus JS](https://stimulus.hotwired.dev/) - Front-end JS
- [Heroku](https://heroku.com/) - Deployment
- [PostgreSQL](https://www.postgresql.org/) - Database
- [Bootstrap](https://getbootstrap.com/) — Styling
- [Figma](https://www.figma.com) — Prototyping

## Team Members
- [Yumi Kimura](https://github.com/kimurayumixy)
- [Erika Ura](https://github.com/ErikaUra)
- [Soren Umstot](https://github.com/sumstot)

## License
This project is licensed under the MIT License
