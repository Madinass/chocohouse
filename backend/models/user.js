import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
  name: { type: String, default: "Қолданушы" }, // 👈 енді name міндетті емес
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
});

export default mongoose.model("User", userSchema);


// import mongoose from 'mongoose';

// const userSchema = new mongoose.Schema({
//   email: { type: String, required: true, unique: true },
//   password: { type: String, required: true }
// }, { timestamps: true });

// export default mongoose.model('User', userSchema);
