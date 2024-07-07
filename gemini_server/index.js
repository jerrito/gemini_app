const express= require("express");
const {people,products}=require("./data/data");
const mongoose=require("mongoose");
const firebase=require("firebase/app");
const cors=require("cors/");
const bodyParser=require("body-parser");
const authRouter=require("./routes/auth");
const userModel=require("./models/user")
const bcrypt=require("bcryptjs")


const app=express();

const auth=require("./middlewares/auth")

const databaseUrl="mongodb+srv://jerrito0240:kI02PBzyF2U1WL9A@cluster0.gldghvy.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";



const port=4000;
mongoose.connect(databaseUrl).then(()=>{
console.log("Database connected successfully");
}).catch((e)=>{
  console.log("Error connecting to database");
});


app.use(express.json());
app.use(bodyParser.json());
app.use(cors());
app.use(auth);
app.use(authRouter);

firebase.initializeApp(
  {
    apiKey:"AIzaSyBwO1WSwiAJqN9Wcn0olgQPJUYXrNTy7Ps",
    authDomain:"127.0.0.1",
    projectId:"woww-b2885",
  }
)

// app.post("/jerrito_gemini/signup",async(req,res)=>{
//   try{
//   const {name,email,password}=req.body;
  
//   const emailAlreadyExist=await userModel.findOne({email})
//   console.log(req.body);
//   if(emailAlreadyExist){
//     return  res.status(400).json({msg:"Email already exist"});
//   }
//   const passwordHashed=await bcrypt.hash(password,8);

//   let user=  userModel({
//     userName:name,
//       email,
//   password:passwordHashed
//   })

//   const data= await user.save();
//   return res.status(200).json({msg:"Saved successfully"})
//   }
//   catch(e){
//    return   res.status(500).json({error:e.message});
//   }
// })

app.post("/jerrito-gemini/otp/",async(req,res)=>{
try{
  const phoneNumber=req.body.phoneNumber;

const confirmationResult=await firebase.auth().signInWithPhoneNumber(
  phoneNumber,
  applicationVerifier
);

   res.status(200).json({"phoneNumber":confirmationResult})
  }catch(e){
    res.status(500).json({msg:e.message});
  }
});

app.post("jerrito-gemini/verify_otp",async(req,res)=>{

  try{
  const confirmationResult=req.body.confirmationResult;
  const code=req.body.code;
  
  await confirmationResult.confirm(code);
  const user=firebase.auth().currentUser;

  res.status(200).send({
    user:user
  });
  }catch(e){
    res.status(500).json({msg:e.message});
  }


})




app.get("/jerrito_gemini",(req,res)=>{

    return res.status(200).send("Page");
});


app.get("/about",(req,res)=>{
   return res.json({"Done":"Finish"});
})

app.get("/all",(req,res)=>{
   const data=people.map((e)=>e.name);

   res.send(data);
})

app.get("/people/:nameReq",(req,res)=>{
    const {nameReq}=req.params;
    console.log(nameReq);
    console.log(req.params);
    console.log(req.body);

    const person=people.find((e)=>
    {return  e.name==nameReq});
   if(!person){
    return res.status(404).send("Unknown");
   }
  return  res.status(200).send(person.name);
    
})

app.get("*",(req,res)=>
{
  res.status(404).send("Page not found");  
});


app.listen(port,"0.0.0.0",()=>{
    console.log(`Started at port ${port}`);
})

