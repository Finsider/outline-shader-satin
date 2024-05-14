package com.example;

import ladysnake.satin.api.event.ShaderEffectRenderCallback;
import ladysnake.satin.api.experimental.ReadableDepthFramebuffer;
import ladysnake.satin.api.managed.ManagedShaderEffect;
import ladysnake.satin.api.managed.ShaderEffectManager;
import net.fabricmc.api.ModInitializer;

import net.fabricmc.fabric.api.client.event.lifecycle.v1.ClientTickEvents;
import net.fabricmc.fabric.api.client.keybinding.v1.KeyBindingHelper;
import net.minecraft.client.MinecraftClient;
import net.minecraft.client.option.KeyBinding;
import net.minecraft.util.Identifier;
import org.lwjgl.glfw.GLFW;


public class Outlineshader implements ModInitializer {
	// This logger is used to write text to the console and the log file.
	// It is considered best practice to use your mod id as the logger's name.
	// That way, it's clear which mod wrote info, warnings, and errors.
	public static final	Identifier OUTLINE_SHADER = new Identifier("outlineshader", "shaders/post/transparency.json");
	private static final ManagedShaderEffect shader = ShaderEffectManager.getInstance().manage(OUTLINE_SHADER, managedShaderEffect -> {
		managedShaderEffect.setSamplerUniform("ParticlesDepthSampler", ((ReadableDepthFramebuffer)MinecraftClient.getInstance().getFramebuffer()).getStillDepthMap());
	});
	private static boolean toggle = true;
	private static final KeyBinding toggleShaderKey = KeyBindingHelper.registerKeyBinding(
			new KeyBinding("Toggle Shader", GLFW.GLFW_KEY_APOSTROPHE, "key.categories.misc")
	);

	@Override
	public void onInitialize() {
		// This code runs as soon as Minecraft is in a mod-load-ready state.
		// However, some things (like resources) may still be uninitialized.
		// Proceed with mild caution.
		ClientTickEvents.END_CLIENT_TICK.register(client -> {
			if (toggleShaderKey.wasPressed()) {
                toggle = !toggle;
			}
		});
		ShaderEffectRenderCallback.EVENT.register(tickDelta -> {
			if(toggle) {
				shader.render(tickDelta);
			}
		});
	}
}