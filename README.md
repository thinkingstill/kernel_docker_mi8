# 编译kernel
## 同步 lineageOS 22.1 mi8的内核和编译工具
- git clone -b lineage-22.1 https://github.com/LineageOS/android_kernel_xiaomi_sdm845.git
- git clone https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9.git

## 适配文件
- 只需要编译内核，因此不需要lineageOS 代码。但prebuilts_gcc需要配置下，实际可以的工具是`real-aarch64-linux-android-gcc`(需要把这个改名成`aarch64-linux-android-gcc-4.9`)
- mi8 内核的defconfig文件需要使用vendor目录里的sdm845和dipper直接cat合并即可成merge_defconfig文件

## 配置环境和编译
- 安装 make arm32 等交叉编译环境
- 执行 build.sh 等待编译。注意，会有些报错，直接问大模型，都能比较容易处理，此处不在详细记录
- 编译产出在指定out目录arch/arm64/boot里

## 打包镜像
-- 同步 https://github.com/osm0sis/AnyKernel3
-- 编译产出只用 Image.gz-dtb 即可，按 AnyKernel3 使用方法打包即可

# 刷入OS
## 刷入 lineageOS 22.1, 注意一定按文档要刷入指定 MIUI 底包
## 推荐 OrangeFox Recovery, 完美配合 lineageOS 22.1
## 刷入Magisk, 最优是这步输入，这样后续来回调试kernel不用反复用Magisk处理boot

# 开启docker
## 安装 termux、root-repo、docker，一定需要root
## 挂载cgroup 
- `sudo mount -t tmpfs -o uid=0,gid=0,mode=0755 cgroup /sys/fs/cgroup`
- `sudo dockerd --iptables=false`
- 正常简单 docker 就可以使用了 ，但复杂的 docker 应用尤其涉及到文件操作等，目前还不能很好支持
- 可以一并把 SMB、NFS 等文件模块一起刷入内核，merge_defconf已经配置

# 配置docker-compose
- 从 docker compose 的 github 上下载适合 aarch64 的 docker-compose 二进制文件
- mv 到 termux 到 /usr/bin下
- docker-compose 默认unix path 在 /var/runx下，使用时需要`sudo  DOCKER_HOST=unix:///data/data/com.termux/files/usr/var/run/docker.sock  docker-compose  up` 
# 总结
- 上述过程会遇到内核功能没开启情况，会多次修改和编译，使用menuconf和大模型工具，整体还算顺利
- 网上搜索到的内核功能check代码
    <code>
      pkg install tsu
      pkg install wget
      wget https://raw.githubusercontent.com/moby/moby/master/contrib/check-config.sh
      chmod +x check-config.sh
      sed -i '1s_.*_#!/data/data/com.termux/files/usr/bin/bash_' check-config.sh
      sudo ./check-config.sh
    </code>
