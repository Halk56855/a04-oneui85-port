.class public Landroid/os/SemSystemProperties;
.super Ljava/lang/Object;
.source "SemSystemProperties.java"

# direct methods
.method public static getInt(Ljava/lang/String;I)I
    .locals 2
    .param p0, "key"    # Ljava/lang/String;
    .param p1, "def"    # I

    const-string v0, "ro.product.model"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :cond_camera_check

    const/4 v0, 0x0
    return v0

    :cond_camera_check
    const-string v0, "ro.product.device"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :cond_default

    # Galaxy A04 (a04 / SM-A045F) default integer fallback
    return p1

    :cond_default
    invoke-static {p0, p1}, Landroid/os/SystemProperties;->native_get_int(Ljava/lang/String;I)I
    move-result v0
    return v0
.end method
