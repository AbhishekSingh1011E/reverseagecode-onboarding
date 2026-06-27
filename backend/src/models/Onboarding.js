const mongoose = require('mongoose');

const onboardingSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, 'Name is required'],
      minlength: [2, 'Name must be at least 2 characters'],
      trim: true,
    },
    dob: {
      type: Date,
      required: [true, 'Date of birth is required'],
      validate: {
        validator: (value) => value <= new Date(),
        message: 'Date of birth cannot be a future date',
      },
    },
    gender: {
      type: String,
      required: [true, 'Gender is required'],
      enum: {
        values: ['Male', 'Female', 'Other'],
        message: 'Gender must be Male, Female, or Other',
      },
    },
    lifestyle: {
      type: String,
      required: [true, 'Lifestyle is required'],
      enum: {
        values: ['Sedentary', 'Lightly Active', 'Moderately Active', 'Very Active'],
        message: 'Invalid lifestyle value',
      },
    },
    weight: {
      type: Number,
      required: [true, 'Weight is required'],
      min: [20, 'Weight must be at least 20kg'],
      max: [300, 'Weight must be at most 300kg'],
    },
    height: {
      type: Number,
      required: [true, 'Height is required'],
      min: [50, 'Height must be at least 50cm'],
      max: [250, 'Height must be at most 250cm'],
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Onboarding', onboardingSchema);
