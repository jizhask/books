# fsbooks

集体写一本书，这真是一件令人振奋的事情。如果一本不过瘾，那就写两本。

* 《FreeSWITCH案例大全》 fsbook-case-study
* 《FreeSWITCH参考手册》 fsbook-references

源文件使用Markdown格式，排版使用Pandoc和Latex。参见[《我在Mac上的写作工具链》](http://mp.weixin.qq.com/s?__biz=MjM5MzIwMzExMg==&mid=222341648&idx=1&sn=1a6c4c69e57194153080050b352b8d2e&mpshare=1&scene=1&srcid=1019tXeqPF7qSccOsyBM0GK7#rd)。

关于Markdown格式请参考已有的内容。欢迎大家配置好自己的Pandoc环境，我们推荐使用我们的`docker`镜像生成PDF，这样可以检查自己的Markdown语法等。但配置不起来也没什么问题。我们会有专人负责格式。


## 生成PDF

根据自己的来表示，可以生成PDF或HTML来查看转换效果，推荐生成PDF，以下是基本使用方法。

* 生成全书。分别进入每本书的主目录然后执行`make`：


```
cd fsbook-case-stuby
make
```

```
cd fsbook-references
make
```

* 每章生成单个PDF。速度会比生成全书要快。进入书的主目录，然后执行：


```
make pdfs
```

* 仅生成单个PDF

```
make out/chapter2.pdf
```


## 《FreeSWITCH案例大全》

* 按照《FreeSWITCH实例解析》的格式来写。
* 有些内容是跟时间和空间有关的，建议在开头注明写作时间和作者，如`2016-10-22/Seven`。

## 《FreeSWITCH参考手册》

主要内容：

* 模块 （杜金房）
* 通道变量
* API参考
* App参考


## 行文规范

**注意排版。**

* 使用Markdown格式，如果本规范中未规定的，参考已有的内容。
* 正文中使用中文标点。
* 代码有专门的格式，如`code`，或缩进四格为代码段：

    // this is a comment line in code
    // 这是一行注释

或有语法加亮功能的代码段：

```c
	/* 这是一段很长很长的代码 */
	int a, b c;
	char *freeswitch;
```

* 如果代码需要加行号，可以用`nl`命令，如，我在Mac上有一个脚本，可以加亮后直接Copy到剪贴板上：

```bash
#!bin/bash
nl -b a $@ | pbcopy
```

* 图片、抓屏等，尽量只抓必要的部分。把重要的内容放大后抓取。由于排版限制，尽量使用宽高比大于或等于`2:1`的图片（必要情况下可以两侧加白边），在排版中会有较好的效果。如，以下命令可以使用ImageMagic把现有图片两侧加白边（需要先用`identify`找到图像大小，再把宽度加大：

	convert -gravity center -background white -extent 1200x700 autotools.png autotools-2.png


插入图片可参考如下代码片断：

```
接着在命令控制台上输入以下命令，便会看到一辆小火车开过，如图\ref{fig:cluechoo}：

     freeswitch> cluechoo

![\label{fig:cluechoo}ClueChoo小火车](images/cluechoo.png)
```


## 协作流程

在多人写作过程中，可能有一些冲突。为避免不必要的冲突，我们建议使用如下流程：

* 先在群里跟大家讨论要写的内容
* 如果一个内容有多个人同时写，则可以有一个主要负责人，其它人统一由这个负责人协调
* 想象一下这是一个多线程的事情，因此每个人在访问共享资源的时候要先获取一个“锁”。
* 更新[WORKING.md](./WORKING.md)以获取锁。


## 注意事项

* 本仓库是私有的，不要Fork和公开本仓库。
* 所有提交都提交到Master分支上。注意尽量避免冲突。当然，如果不确定，也可以自己创建分支，并提交pr，由杜老师审核。
* 可以直接在 https://git.xswitch.cn 上提交。
* 可以在Windows系统上工作，但要使用UNIX换行符。文件尾部必须有换行符。
* 中文使用UTF-8编码。需要一个称手的编辑器。可以使用Sublime Text之类的编辑器。不要用Windows记事本。
* 每次修改前都先`pull`最新的，以减少冲突。为了保持一个清淅的提交历史，建议使用rebase方式更新`master`，如，修改 `.git/config`：

```
[branch "master"]
        remote = origin
        merge = refs/heads/master
        rebase = true
```

## Tips and Tricks

生成API命令列表：

	gcc -E mod_commands.c | grep ADD_API | sed -e 's/^[^,]*, "//' | sort | pbcopy

生成APP列表：

    gcc -E mod_dptools.c | grep ADD_APP | sed -e 's/^[^,]*, "//' | sort | pbcopy

取得所有可能的通道变量：

```
cd src

find . -name "*.c" -exec grep switch_channel_get_variable {} \; | sed -e 's/^.*switch_channel_get_variable[^,]*, *"*\([0-9a-zA-Z_]*\).*$/\1/' | sort | uniq

find . -name "*.c" -exec grep switch_channel_get_variable {} \; | sed -e 's/^.*switch_channel_get_variable[^,]*, *"*\([0-9a-zA-Z_]*\).*$/\1/' | sort | uniq > /tmp/a.c

在`a.c`加入`#include <switch_types.h>`

gcc -Iinclude/ -E /tmp/a.c
```

## Pandoc docker

在Mac上和Windows上安装docker后，可以比较方便的生成PDF。

### Makefile方法

如果有`make`，直接执行`make docker`会

`make dockerrun`便可以进入Linux环境，然后执行`make`就可以生成PDF了。

### docker命令

如果在Windows上，也可以使用docker。如拉取docker镜像：

```
docker pull dujinfang/texlive_pandoc
```

以下命令将`d:\fsbooks`目录映射到docker里面的`/team`目录，并进入`bash` Shell环境。

```
docker run --rm -it -v d:\fsbooks:/team dujinfang/texlive_pandoc bash
```

进入Shell后，就可以按通常的方法执行`make`了。


## Pandoc在Windows上的用法

Pandoc可将Markdown格式的文件转换成HTML形式（参考`/fsbooks/fsbook-case-study/html.bat`文件）。

在Windows上成功配置Pandoc后，进入命令行界面。转到`/fsbooks/fsbook-case-study/`目录下，编辑`html.bat`文件，并在命令行下运行`html.bat`，即可生成相应的`html`文件。
html.bat文件内容如下：

```
xcopy /y images out\images\
pandoc -o out/fsbook-case-study.html  -V book="FreeSWITCH案例大全" -V title="FreeSWITCH案例大全"  --template cover.html preface.md chapter1.md chapterx.md postface.md
```

* 第一条指令为：复制相关图片到生成路径下。（章节中调用的图片和生成的html文件在一个文件夹下，比如都在out/下）
* 第二条指令为：将`.md`文件依照`cover.html`格式转换并输出到`out`文件夹下，并命名为`fsbook-case-study.html`。
* 执行`.bat`文件如果出现标题文字乱码，主要是编码格式不对，可先用记事本编辑`.bat`文件，保存时编码选择“ANSI”即可。
* `--template cover.html`后面可以随时添加章节`chapterX.md`转换



## 权益声明

每个人的作品自己有版权。如果以后书能大卖，或许每个人都能获得一些收益，但是，不要指望写书挣钱，把这个过程更多的看作是一种贡献。与其计算每个人应该分多少钱，不如我们一起支持一个开源项目或捐赠一个公益事业。
