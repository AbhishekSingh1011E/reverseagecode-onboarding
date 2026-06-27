const express = require('express');
const mongoose =  require('mongoose');
const cors = require("cors")
require("dotenv").config();

const onboardingRoutes = require("./src/routes/onboardingRoutes");
const app = express();

app.use(cors());
app.use(express.json()); 

app.get("/",(req,res)=>{
    res.json({
        message:"ReverseAge Onboarding API is running"
    });
});

app.use("/api/onboarding", onboardingRoutes);

app.use((req, res) => {
    res.status(404).json({
        success: false,
        message: " Route not found"
    });
});

app.use((err, req, res, next ) => {
    console.error(err.stack);
    res.status(500).json({
        success:false,
        message: "Internal server error"
    });
})
const PORT = process.env.PORT || 5000;
const MONGO_URI = process.env.MONGODB_URI || "mongodb://127.0.0.1:27017/reverseagecode";



mongoose
   .connect(MONGO_URI)
   .then(()=>{
    console.log("MongoDB connected");
    app.listen(PORT,()=> console.log(`server running on port ${PORT}`));
   })
   .catch((err)=>{
    console.error("MongoDB connection failed:",err.message);
    process.exit(1);
   })