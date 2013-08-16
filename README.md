## Realtime Debug Portal

### News
说好了开源，拖了很久了，虽然还是有些bugs，代码还是没有整理好。
不管了，开源出来，想玩的同学就拿来玩去吧～

### Introduction

RDP是一个类似Web Inspector的工具，把这个工具引入我们的项目工程，并做一些简单的配置，然后启动应用，在浏览器输入手机的IP地址，就可以看到UIView的树状结构和Log信息，还可以在浏览器中对View进行移动，隐藏，选中高亮等操作。


![展示图](http://www.vinqon.com/codeblog/fckeditor/upload/image/2013-06/2_2.png)


更多详细的信息，可以参考这篇博文[《Redesign Your App for iOS 7 之 页面布局》](http://www.vinqon.com/codeblog/?detail/11109 "Redesign Your App for iOS 7 之 页面布局") 



### Usage

把库文件、头文件以及资源文件(bundle)引入项目即可，有两点需要注意一下：

1.    把工程中的Build Settings中的Other Linker Flags设置为-ObjC;
2.    使用iOS5或以上SDK;


然后在合适位置调用以下代码：

	#import "libRDP.h"
	[RDP startServer];

启动应用之后，状态栏会显示出你需要访问的地址，模拟器一般会显示http://127.0.0.1:8080 ，请使用Chrome或者Safari打开。

当选中某个view之后，RDP会在这个view上面盖一层蓝色透明遮罩以便开发者区别。  
用户可以通过按下方向键来移动view，每次会移动1个逻辑像素；按住shift加方向键可以移动10个逻辑像素；  
按住w字母键，加方向键可以调整大小；  
点击h可以切换hidden状态；  



### TODO

###### Font-end
1.	优化页面样式
2.	前端代码拿到github中，跨域访问




### ISSUE
1.	读取View信息的时候偶然会发生crash，可能View读取期间被释放了（知道了还不去fix？！！我是懒到到什么程度了）
2.	用前端轮询的办法来同步View结构信息，拙爆了。之前尝试过分别用Runloop和线程来实现了一下Comet玩长连接，不过1).自己开一个Runloop好像特别耗性能，连mac上的模拟器都hold不住；而2).线程等待的时候会阻塞其他请求，造成岩石很厉害。好吧，还是不纠结这些了，下期用WebSoket来弄，开源库都已经找好了。
