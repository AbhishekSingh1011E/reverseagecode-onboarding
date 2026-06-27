const validateOnboarding = (req, res,  next)=> {
    const  {name, dob, gender, lifestyle, weight, height} = req.body;
    const errors = [];

    if(!name || name.trim().length < 2) {
        errors.push("Name must be at  least 2 char");
    }
    if(!dob){
        errors.push("Date of birth is required");
    } else {
        const dobDate = new Date(dob);
        if (isNaN(dobDate.getTime())) {
            errors.push("Invalid date of birth");
        } else if (dobDate > new Date()) {
            errors.push("Date of birth cannot be in the future");
        }
    }

    const validGenders =  ["Male", "Female","Other"];
  if (!gender || !validGenders.includes(gender)) {
        errors.push("Gender must be Male, Female or Other");
    }

    const validLifestyles = [
         "Sedentary",
         "Lightly Active",
         "Moderately Active",
         "Very Active",
    ];
    if(!lifestyle || !validLifestyles.includes(lifestyle)) {
        errors.push("Invalid lifestyle selected");
    }
    if(weight === undefined || weight === null || isNaN(weight)){
        errors.push("Weight is required");

    } else if(weight < 20 || weight > 300) {
         errors.push("Weight must be between 20kg and 300kg");
    }

    if(height === undefined || height === null || isNaN(height)){
        errors.push("Height is required");

    } else if(height < 50 || height > 250) {
         errors.push("Height must be between 50cm and 250cm");
    }

    if(errors.length > 0){
        return res.status(400).json({
            success: false,
            errors

        })
    }
    next();
}
module.exports = validateOnboarding;