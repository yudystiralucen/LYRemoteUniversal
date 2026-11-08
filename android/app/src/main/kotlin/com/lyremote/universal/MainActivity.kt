package com.lyremote.universal

import android.content.Context
import android.hardware.ConsumerIrManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channel = "com.lyremote.universal/ir"

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channel
        ).setMethodCallHandler { call, result ->

            val ir = getSystemService(
                Context.CONSUMER_IR_SERVICE
            ) as? ConsumerIrManager

            when (call.method) {
                "hasIrEmitter" -> {
                    result.success(ir?.hasIrEmitter() == true)
                }

                "transmit" -> {
                    if (ir == null || !ir.hasIrEmitter()) {
                        result.error("NO_IR", "IR tidak tersedia", null)
                    } else {
                        try {
                            val frequency =
                                call.argument<Int>("frequency") ?: 38000

                            val pattern =
                                call.argument<List<Int>>("pattern")
                                    ?.toIntArray()

                            if (pattern == null ||
                                pattern.isEmpty() ||
                                pattern.size % 2 != 0 ||
                                pattern.any { it <= 0 }) {
                                result.error(
                                    "INVALID_PATTERN",
                                    "Pola IR tidak valid",
                                    null
                                )
                            } else {
                                ir.transmit(frequency, pattern)
                                result.success(true)
                            }
                        } catch (e: Exception) {
                            result.error(
                                "IR_ERROR",
                                e.message,
                                null
                            )
                        }
                    }
                }

                else -> result.notImplemented()
            }
        }
    }
}
