define("index",["jquery","tmpl"],function(require,exports,module){

	var tmpl = require("tmpl");
	var expandedAddress = {};
	var lastUpdate = -1;
	var selectedAddress = null;

	var refreshViewTree = function(cb){

		$.get("/api/loadViewTree",{"lastupdate":lastUpdate},function(data){
			var data = JSON.parse(data).data;
			var json = null;

			if (data.code == 304) return;
			
			json = data.content;
			lastUpdate = data.lastUpdate;

			$("#viewtree article").html(viewObj2HTML(json));

			$("li.viewnode").on("click",function(e){
				if ($(this).hasClass("selected")) {
					$(this).removeClass("selected");
					selectedAddress = null;
				}else{
					$("li.viewnode.selected").removeClass("selected"); 
					$(this).addClass("selected");
					selectedAddress = $(this).attr("address");
				}
				$.get("/api/highlightView",{address:$(this).attr("address")});
			});

			$("a.arrow").on("click",function(e){
				$viewnode = $(this).parent();
				if ($viewnode.hasClass("expanded")) {
					$viewnode.removeClass("expanded");
					delete(expandedAddress[$viewnode.attr("address")]);
				}else{
					$viewnode.addClass("expanded");
					expandedAddress[$viewnode.attr("address")] = 1;
				}

				e.stopPropagation();
			});

			cb && cb();

			if (selectedAddress) {
				$("li.viewnode[address="+selectedAddress+"]").addClass("selected");
			};

			for(var address in expandedAddress){
				$("li.viewnode[address="+address+"]").addClass("expanded");
			}
		});
	};

	var viewObj2HTML = function(view){
		var HTML = tmpl("<li class=viewnode address=<%=view.address%> frame=<%=view.x%>|<%=view.y%>|<%=view.w%>|<%=view.h%>>"+
							"<%if(view.subviews && view.subviews.length>0){%><a class=arrow></a><%}%>"+
							"<a class=viewinfo href=javascript:void(0)>&lt;"+
								"<span class=h1><%=view.class%></span>&nbsp;"+
								"<span class=h2>frame</span>=<span class=h3>&quot;(<%=view.x%>,<%=view.y%>,<%=view.w%>,<%=view.h%>)&quot;</span>&nbsp;"+
								"<span class=h2>bounds</span>=<span class=h3>&quot;(<%=view.bx%>,<%=view.by%>,<%=view.bw%>,<%=view.bh%>)&quot;</span>&nbsp;"+
								"<span class=h2>hidden</span>=<span class=h3>&quot;<%=view.hidden?'YES':'NO'%>&quot;</span>&nbsp;"+
								"<span class=h2>address</span>=<span class=h3>&quot;<%=view.address%>&quot;</span>&gt;"+
							"</a>"+
						"</li>",{view:view});
		if(view.subviews){
			HTML += "<ol>";
			for(var i = view.subviews.length-1;i >=0 ;i--){
				HTML += viewObj2HTML(view.subviews[i]);
			}
			HTML += "</ol>";
		}
		return HTML;

	};

	var loadLog = function(cb){

		$.get("/api/loadLog",function(data){
			var data = JSON.parse(data).data;
			var json = null;

			if (data.code == 404) return;
			
			json = data.content;

			if (json && json.length > 0 ) {
              
				console && console.log && console.log(json);
              
				container  = $("#console article")[0];
				container.innerHTML += log2HTML(json);
				container.scrollTop = container.scrollHeight;
              
			};

			cb && cb();

		});
	}

	var log2HTML = function(list){
		var HTML = tmpl("<%for(var i = 0;i<list.length;i++){%>"+
				"<%if(list[i].content&&list[i].content.length>0){%><div><%=list[i].content%></div><%}%>"+
			"<%}%>",{list:list});

		return HTML;
	};

	$(function(){

		refreshViewTree();

		var shifting = false;
		var widthsetting = false;
		window.onkeyup = function(e){
			if(e.keyCode == 16){
				shifting = false;
			}
			if(e.keyCode == 87){
				widthsetting = false;
			}
		};

		window.onkeydown = function(e){
			if(e.keyCode == 16){
				shifting = true;
				return;
			}

			if(e.keyCode == 87){
				widthsetting = true;
				return;
			}

			if((e.keyCode >= 37 && e.keyCode <=40)||e.keyCode == 72){

				var selectedView = $("li.viewnode.selected");
				if (!selectedView.length) return;

				e.preventDefault();

				var frame = selectedView.attr("frame").split("|");
				var x = frame[0]*1;
				var y = frame[1]*1;
				var w = frame[2]*1;
				var h = frame[3]*1;
				var sethidden = false;

				var offset = 1;
				if (shifting) offset = 10;

				if (widthsetting) {
					if (e.keyCode == 37) {//left
						w -= offset;
					}else if(e.keyCode == 38){//up
						h -= offset;
					}else if(e.keyCode == 39){//right
						w += offset;
					}else if(e.keyCode == 40){//down
						h += offset;
					}
				}else{
					if (e.keyCode == 37) {//left
						x -= offset;
					}else if(e.keyCode == 38){//up
						y -= offset;
					}else if(e.keyCode == 39){//right
						x += offset;
					}else if(e.keyCode == 40){//down
						y += offset;
					}
				}

				if (e.keyCode==72) {

					sethidden = true;
				};

				selectedView.attr("frame",(x+"|"+y+"|"+w+"|"+h));

				$.get("/api/moveView",{address:selectedView.attr("address"),x:x,y:y,w:w,h:h,hidden:sethidden},function(){
					window.needToRefresh = true;
				});

				return false;
			}
		};


		setInterval(function(){
			if (window.needToRefresh){
				refreshViewTree();
				window.needToRefresh = false;
			}
		},1000);

		setInterval(function(){
			window.needToRefresh = true;
		},1500);


		var keepLoadLog = function(){
			loadLog(function(){
				setTimeout(keepLoadLog,500);
			});
		};

		keepLoadLog();
		
	});

});