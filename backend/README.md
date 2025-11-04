# Choco House - Backend (Express + MongoDB)

## Quick start (local)

1. Make sure MongoDB is running locally (you said you have MongoDB Compass).
   Default connection string used: `mongodb://127.0.0.1:27017/choco_house`

2. Unzip and open the backend folder, then install dependencies:
```
cd backend
npm install
```

3. Start the server:
```
npm run start
```
or for development with auto-reload (if you have nodemon):
```
npm run dev
```

4. API base URL:
```
http://127.0.0.1:5000/api
```
- Signup: POST `/api/auth/signup`  { email, password }
- Login:  POST `/api/auth/login`   { email, password } -> returns token
- Get cakes: GET `/api/cakes`
- Add cake: POST `/api/cakes` { name, price, imageUrl, description }
- Delete cake: DELETE `/api/cakes/:id`

## Notes
- For production, set `MONGO_URL` and `JWT_SECRET` environment variables.
- This project uses ES modules (`"type": "module"` in package.json).
