
// These two lines are required to initialize Express in Cloud Code.
 express = require('express');
 app = express();

// Global app configuration section
app.set('views', 'cloud/views');  // Specify the folder to find templates
app.set('view engine', 'ejs');    // Set the template engine
app.use(express.bodyParser());    // Middleware for reading request body

// This is an example of hooking up a request handler with a specific request
// path and HTTP verb using the Express routing API.
app.get('/hello', function(req, res) {
  res.render('hello', { message: 'Congrats, you just set up your app!' });
  console.log('yo');
});
app.get('/idle',function(req, res){
	var Status = Parse.Object.extend("Status");
	var query = new Parse.Query(Status);
	query.equalTo('device','P');
	query.equalTo('behavior','idle');
	query.find({
		success:function(data){
            res.send((data.length==0?'0':'1'));
		},
		error:function(error,data){
			res.send('idle error');
		}
	});
});
app.get('/like',function(req,res){
	var Status = Parse.Object.extend("Status");
	var query = new Parse.Query(Status);
	query.equalTo('device','P');
	query.equalTo('behavior','like');
	query.find({
		success:function(data){
            res.send((data.length==0?'0':'1'));
		},
		error:function(error,data){
			res.send('like error');
		}
	});	
});
app.get('/dislike',function(req,res){
	var Status = Parse.Object.extend("Status");
	var query = new Parse.Query(Status);
	query.equalTo('device','P');
	query.equalTo('behavior','dislike');
	query.find({
		success:function(data){
            res.send((data.length==0?'0':'1'));
		},
		error:function(error,data){
			res.send('dislike error');
		}
	});	
});
app.get('/comment',function(req,res){
	var Status = Parse.Object.extend("Status");
	var query = new Parse.Query(Status);
	query.equalTo('device','P');
	query.equalTo('behavior','comment_done');
	query.find({
		success:function(data){
            res.send((data.length==0?'0':'1'));
		},
		error:function(error,data){
			res.send('comment error');
		}
	});	
});

app.get('/select/:id', function(req, res) {
      var Status = Parse.Object.extend("Status");
	  var Building = Parse.Object.extend("Building");
	  var query = new Parse.Query(Status);
	  query.equalTo('device','T');
	  query.find({
		  success:function(data){
			  for(var i=0;i<data.length;i++){
				  data[i].destroy({
					  success:function(data){
						  console.log('destroy'+i+' success');
					  },
					  error:function(error,data){
					  	  res.send('delete error');
					  }
				  });
			  }
			  query2 = new Parse.Query(Building);
			  query2.equalTo("bid",parseInt(req.params.id));
			  query2.find({
				  success:function(data){
					  var status = new Status();
					  status.set("behavior",'select');
					  status.set("device",'T');
					  status.set("obj",data[0]);
					  status.set("bid",parseInt(req.params.id));
					  status.save(null,{
						  success:function(data){
							  res.send('select No.'+req.params.id+' success.');
						  },
						  error:function(error,data){
							  res.send('select No.'+req.params.id+' fail.');
						  }
					  });
				  },
				  error:function(error,data){
					  res.send('find error in select');
				  }
		        });
			  
		  },
		  error:function(error,data){
			  res.send('find error in delete');	
		  }
	  });	  
});	

app.get('/thermodynamic', function(req,res){
	   var Building = Parse.Object.extend("Building");
	   var query = new Parse.Query(Building);
	   query.ascending('bid');	   
	   query.find({
		   success:function(data){
			   var like = 0;
			   var dislike = 0;
			   for(var i=0;i<data.length;i++){
				   like += data[i].get('like');
				   dislike += data[i].get('dislike');
			   }
			   var obj = function(){
				   this.bid = 0;
				   this.type = 'none';
				   this.percent = 0;
				   this.like = 0;
				   this.dislike = 0;
			   };
			   var objArr = [];
			   for(var j=0;j<data.length;j++){
				   objArr[j] = new obj();
				   objArr[j]['bid'] = data[j].get('bid');
				   objArr[j]['like'] = data[j].get('like');
				   objArr[j]['dislike'] = data[j].get('dislike');
				   if(data[j].get('dislike')==data[j].get('like')){
				     objArr[j]['type'] = 'draw';
				     objArr[j]['percent'] = 0;
			       }
				   else{
  				     objArr[j]['type'] = ( data[j].get('dislike') > data[j].get('like') ? 'dislike' : 'like' );
  				     objArr[j]['percent'] = ( data[j].get('dislike') > data[j].get('like') ? data[j].get('dislike')/dislike : data[j].get('like')/like );
				   }
			   }
			   res.send(objArr);			    
		   },
		   error:function(error,data){
		   	   res.send("thermodynamic fail");
		   }
	   });
});
app.get('/update/like/:id',function(req,res){
   var Building = Parse.Object.extend("Building");
   var query = new Parse.Query(Building);
   query.equalTo('bid',parseInt(req.params.id));
   query.find({
   	   success:function(data){
   	   	   data[0].set('like',parseInt(data[0].get('like'))+1);
		   data[0].save({
		   	   success:function(data){
		   	   	   res.send("update-like success");
		   	   },
			   error:function(error,data){
			   	   res.send("update-like update error");
			   }
		   });
   	   },
	   error:function(error,data){
	   	   res.send("update-like find error");
	   }
   })
});
app.get('/update/dislike/:id',function(req,res){
    var Building = Parse.Object.extend("Building");
    var query = new Parse.Query(Building);
    query.equalTo('bid',parseInt(req.params.id));
    query.find({
    	   success:function(data){
    	   	   data[0].set('dislike',parseInt(data[0].get('dislike'))+1);
 		   data[0].save({
 		   	   success:function(data){
 		   	   	   res.send("update-dislike success");
 		   	   },
 			   error:function(error,data){
 			   	   res.send("update-dislike update error");
 			   }
 		   });
    	   },
 	   error:function(error,data){
 	   	   res.send("update-dislike find error");
 	   }
    })	
});
app.get('/initAll',function(req,res){
	var Building = Parse.Object.extend("Building");
	var query = new parse.Query(Building);
	query.find({
		success:function(data){
			for(var i=0;i<data.length;i++){
				data[i].set("like",0);
				data[i].set("dislkike",0);
				data[i].save({
					success:function(data){
					    res.send("success "+i);	
					}, 
					error:function(error,data){
						res.send("init update error "+i);
					}
				});
			}
		},
		error:function(error,data){
			res.send("init find errors");
		}
	});
	var Comment = Parse.Object.extend("Comment");
	var CommentBackup = Parse.Object.extend("CommentBackup");
	var query = new parse.Query(Comment);
	query.find({
		success:function(data){
			for(var i=0;i<data.length;i++){
				var backup = new CommentBackup();
				backup.set("id",data[i].get("id"));
				backup.set("comment",data[i].get("comment"));
				backup.save({
					success:function(data){
						res.send("success "+i);
					},
					error:function(error,data){
						res.send("comment backup error");
					}
				});
			}
		},
		error:function(error,data){
			res.send("comment find error");	
		}
	});
});
// // Example reading from the request query string of an HTTP get request.
// app.get('/test', function(req, res) {
//   // GET http://example.parseapp.com/test?message=hello
//   res.send(req.query.message);
// });

// // Example reading from the request body of an HTTP post request.
// app.post('/test', function(req, res) {
//   // POST http://example.parseapp.com/test (with request body "message=hello")
//   res.send(req.body.message);
// });

// Attach the Express app to Cloud Code.
app.listen();
