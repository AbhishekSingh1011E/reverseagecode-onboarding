const Onboarding =  require("../models/Onboarding");
const createOnboarding =  async(req ,res) => {
    try{
        const {name, dob, gender, lifestyle, weight, height} = req.body;
        const profile = await Onboarding.create({
            name,
            dob,
            gender,
            lifestyle,
            weight,
            height,
        });
        console.log("Saved to DB:", profile.toObject());
        return res.status(201).json({
            success: true,
            message : "Profile created",
            id: profile._id
        })

    } catch(error){
        if(error.name === "ValidationError"){
            const message = Object.values(error.errors).map((e)=>e.message);
            return res.status(400).json({
                success:false,
                error : message
            });
        }
        return res.status(500).json({
            success: false,
            message: "Server error.can not create profile"
        });
    }
    
}

const getOnboarding = async(req ,res) => {
    try{
         const profile = await Onboarding.findById(req.params.id);
         if(!profile){
            return res.status(404).json({
                success: false,
                message: "profile not found",
            });
         }
          return res.status(200).json({
            success: true,
            data: profile,
          });
    } catch(error) {
        if(error.name === "CastError") {
            return res.status(404).json({
                success:false,
                message: " profile not found"
            });
        }
        return res.status(500).json({
            success: false,
            message: "server error. could not fetch profile.",
        });
    }
}
module.exports = {createOnboarding , getOnboarding};
