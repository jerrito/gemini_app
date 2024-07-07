const mongoose=require("mongoose");

const model=mongoose.Schema({

    userName:{
        type:String,
        trim:true,
        required:true

        
    },
    email:{
        type:String,
        trim:true,
       validate:{
        validator:(value)=>{
            const re=/^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
         return value.match(re);
        },
        message:"Please enter a valid email address"
       }

    },
    password:{
        type:String,
        trim:true,
        validate:{
            validator:(value)=>{
                return value.length>=6;
            },
            message:"Password length less than 6 characters"
        }
    }
    
});

const userModel=mongoose.model("gemini_user",model);

module.exports=userModel;