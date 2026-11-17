package dev.tr7zw.exordium.validation;

import net.fabricmc.api.ClientModInitializer;
import net.minecraft.client.Minecraft;

public final class DebugOverlay implements ClientModInitializer {
    @Override
    public void onInitializeClient() {
        Thread worker = new Thread(() -> {
            while (!Thread.currentThread().isInterrupted()) {
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException exception) {
                    Thread.currentThread().interrupt();
                    return;
                }
                Minecraft.getInstance().execute(() -> {
                    Minecraft minecraft = Minecraft.getInstance();
                    if (minecraft.player != null) {
                        minecraft.debugEntries.setOverlayVisible(true);
                    }
                });
            }
        }, "Exordium validation");
        worker.setDaemon(true);
        worker.start();
    }
}
