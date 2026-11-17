package dev.tr7zw.exordium.port;

import com.llamalad7.mixinextras.injector.ModifyExpressionValue;
import com.llamalad7.mixinextras.injector.wrapoperation.Operation;
import com.llamalad7.mixinextras.injector.wrapoperation.WrapOperation;
import com.mojang.blaze3d.pipeline.RenderTarget;
import com.mojang.blaze3d.pipeline.TextureTarget;
import com.mojang.blaze3d.systems.RenderSystem;
import net.minecraft.client.Minecraft;
import net.minecraft.client.gui.render.GuiRenderer;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(GuiRenderer.class)
public class GuiRendererMixin {
    @Unique private RenderTarget exordium$cache;
    @Unique private boolean exordium$capturing;
    @Unique private long exordium$nextFrame;
    @Unique private int exordium$scale;

    @WrapOperation(method = "render", at = @At(value = "INVOKE",
            target = "Lnet/minecraft/client/gui/render/GuiRenderer;draw()V"))
    private void exordium$draw(GuiRenderer renderer, Operation<Void> original) {
        Minecraft minecraft = Minecraft.getInstance();
        if (minecraft.gui.screen() != null || minecraft.level == null) {
            exordium$nextFrame = 0;
            original.call(renderer);
            return;
        }
        RenderTarget output = minecraft.gameRenderer.mainRenderTarget();
        int scale = minecraft.gameRenderer.gameRenderState().windowRenderState.guiScale;
        if (exordium$cache == null || output.width != exordium$cache.width
                || output.height != exordium$cache.height || scale != exordium$scale) {
            exordium$release();
            exordium$cache = new TextureTarget("Exordium HUD", output.width, output.height,
                    output.getColorTexture().getFormat(), output.getDepthTexture().getFormat());
            exordium$scale = scale;
        }
        long now = System.nanoTime();
        if (now >= exordium$nextFrame) {
            RenderSystem.getDevice().createCommandEncoder().clearColorAndDepthTextures(
                    exordium$cache.getColorTexture(), GuiRenderer.CLEAR_COLOR, exordium$cache.getDepthTexture(), 0.0);
            exordium$capturing = true;
            try {
                original.call(renderer);
            } finally {
                exordium$capturing = false;
            }
            exordium$nextFrame = now + 1_000_000_000L / 30;
        }
        exordium$cache.blitAndBlendToTexture(output.getColorTextureView(), output.getDepthTextureView());
    }

    @ModifyExpressionValue(method = "draw", at = @At(value = "INVOKE",
            target = "Lnet/minecraft/client/renderer/GameRenderer;mainRenderTarget()Lcom/mojang/blaze3d/pipeline/RenderTarget;"))
    private RenderTarget exordium$target(RenderTarget original) {
        return exordium$capturing ? exordium$cache : original;
    }

    @Unique
    private void exordium$release() {
        if (exordium$cache != null) {
            exordium$cache.destroyBuffers();
            exordium$cache = null;
        }
        exordium$nextFrame = 0;
    }

    @Inject(method = "close", at = @At("HEAD"))
    private void exordium$close(CallbackInfo ci) {
        exordium$release();
    }
}
