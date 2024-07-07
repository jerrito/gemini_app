const jwt=require("jsonwebtoken");

const auth=async(req,res,next)=>{

    try{
        const token=req.header("tokenId");
        if(!token)res.status(401).json({
            msg:"No auth token, access denied"
        })

        const tokenCheckVerify=jwt.verify(token,'tokenPassword')
        if(!tokenCheckVerify)res.status(401).json({
            msg:"Token verification failed, auhorization denied"
        });

        req.user=tokenCheckVerify.id;
        req.token=token;
        next();
    }
    catch(err){
        console.log(err.message);
        res.status(500).json({error:err.message})
    }
}
module.exports=auth;