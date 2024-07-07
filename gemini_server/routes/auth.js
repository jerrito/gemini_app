const express=require("express")
const userModel=require("../models/user")
const auth=require("../middlewares/auth")
const authRouter=express.Router();
const bcrypt=require("bcryptjs");



authRouter.post("/jerrito_gemini/login",async(req,res)=>{

    const {name,email,password}=req.body;

    const loginUser=await userModel.findOne({
        email, name
    })

  if(!loginUser){
    return res.status(404).json({msg:"No user found"})
  }

  const passwordCheck=bcrypt.compare(password,user.password);
  if(!passwordCheck){
    return res
    .status(400)
    .json({msg:"Password is incorrect"});
  }

const token=  jwt.sign({id:user._id},"tokenPassword")
  res.json({ token, ...user._doc});

  
})


authRouter.post("/jerrito_gemini/verify_token",async (req,res)=>{
    try{
      const token=req.header("tokenId");
    
      if(!token)res.json(false);
    
      const tokenCheckVerify=jwt.verify(token,'tokenPassword')
      if(!tokenCheckVerify)res.json(false);
    
      const user=await userModel.findById(tokenCheckVerify.id);
      console.log(`${user} details`);
      if(!user)res.json(false);
      res.json(true);
    }
    catch(e){
    res.status(500).json({error:e.message});
    }
    })

    
authRouter.get("/jerrito_gemini",auth,async(req,res)=>{
    //console.log(req.user);
  
    const user=await userModel.findById(req.user);
   // console.log(user)
    res.json({...user._doc,token:req.token});
  })
  





authRouter.post("/jerrito_gemini/signup",async(req,res)=>{
    try{
    const {name,email,password}=req.body;
    
    const emailAlreadyExist=userModel.findOne({email})
    console.log(req.body);
    if(emailAlreadyExist){
        return res.status(400).json({msg:"Email already exist"});
    }
    const passwordHashed=await bcrypt.hash(password,8);

    let user=  userModel({
      userName:name,
        email,
    password:passwordHashed
    })

    const data= await user.save();
    return res.status(200).json({msg:"Saved successfully"})
    }
    catch(e){
     return   res.status(500).json({error:e.message});
    }
})

module.exports=authRouter;
