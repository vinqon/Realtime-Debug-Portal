## Realtime Debug Portal

### Introduction

RDP是一个类似Web Inspector的工具，把这个工具引入我们的项目工程，并做一些简单的配置，然后启动应用，在浏览器输入手机的IP地址，就可以看到UIView的树状结构和Log信息，还可以在浏览器中对View进行移动，隐藏，选中高亮等操作。


![展示图](http://www.vinqon.com/codeblog/fckeditor/upload/image/2013-06/2_2.png)


更多详细的信息，可以参考这篇博文[《Redesign Your App for iOS 7 之 页面布局》](http://www.vinqon.com/codeblog/?detail/11109 "Redesign Your App for iOS 7 之 页面布局") 

由于最近较忙，先把framework打包放上来，项目代码还需要一些时间整理。



### Usage

把库文件、头文件以及资源文件(bundle)引入项目即可，有两点需要注意一下：

1.    把工程中的Build Settings中的Other Linker Flags设置为-ObjC;
2.    使用iOS5或以上SDK;


然后在合适位置调用以下代码：

``
#import "libRDP.h"
[RDP startServer];
``

启动应用之后，状态栏会显示出你需要访问的地址，模拟器一般会显示http://127.0.0.1:8080，请使用Chrome或者Safari打开。

当选中某个view之后，RDP会在这个view上面盖一层蓝色透明遮罩以便开发者区别。
用户可以通过按下方向键来移动view，每次会移动1个逻辑像素；按住shift加方向键可以移动10个逻辑像素；
按住w字母键，加方向键可以调整大小；
点击h可以切换hidden状态；



### TODO

###### View Tree
1.	用KVO实现自定义输出和回改属性
2.	浏览器端加入任务队列，顺序请求和执行；

###### Console
1.	加入时间显示
2.	对特殊字符转义
3.	输出系统信息（CPU/内存），以时间轴方式呈现

###### Project
1.	整理代码，写Sample
2.	写文档
3.	开源代码
	