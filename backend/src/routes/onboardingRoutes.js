const express = require("express");
const router =  express.Router();

const {
       createOnboarding,
       getOnboarding,

}  = require("../controllers/onboardingController");
const validateOnboarding =  require("../middleware/validate");

router.post("/", validateOnboarding, createOnboarding);
router.get("/:id",getOnboarding)

module.exports = router;