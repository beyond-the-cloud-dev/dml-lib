<template>
  <div class="animation-controls" role="toolbar" aria-label="Animation controls">
    <!-- Previous Step -->
    <button
      class="control-btn"
      :disabled="currentStep === 0"
      @click="$emit('previous')"
      aria-label="Previous step"
      :aria-keyshortcuts="'ArrowLeft j'"
      title="Previous step (← or J)"
    >
      <span class="btn-icon">←</span>
    </button>

    <!-- Play/Pause -->
    <button
      class="control-btn play-btn"
      :class="{ playing: isPlaying }"
      @click="isPlaying ? $emit('pause') : $emit('play')"
      :aria-label="isPlaying ? 'Pause animation' : 'Play animation'"
      :aria-keyshortcuts="'Space k'"
      :title="isPlaying ? 'Pause (Space or K)' : 'Play (Space or K)'"
    >
      <span class="btn-text">{{ isPlaying ? 'Pause' : 'Play' }}</span>
    </button>

    <!-- Next Step -->
    <button
      class="control-btn"
      :disabled="currentStep >= totalSteps"
      @click="$emit('next')"
      aria-label="Next step"
      :aria-keyshortcuts="'ArrowRight l'"
      title="Next step (→ or L)"
    >
      <span class="btn-icon">→</span>
    </button>

    <!-- Reset -->
    <button
      class="control-btn"
      @click="$emit('reset')"
      aria-label="Reset animation to start"
      :aria-keyshortcuts="'Home 0'"
      title="Reset (Home or 0)"
    >
      <span class="btn-text">Reset</span>
    </button>

    <!-- Speed Control -->
    <div class="speed-control">
      <label for="speed-select" class="speed-label">Speed:</label>
      <select
        id="speed-select"
        :value="speed"
        @change="$emit('speed-change', Number($event.target.value))"
        class="speed-select"
        aria-label="Animation speed"
      >
        <option :value="0.5">0.5×</option>
        <option :value="1">1×</option>
        <option :value="2">2×</option>
      </select>
    </div>
  </div>
</template>

<script setup>
defineProps({
  isPlaying: {
    type: Boolean,
    required: true
  },
  currentStep: {
    type: Number,
    required: true
  },
  totalSteps: {
    type: Number,
    required: true
  },
  speed: {
    type: Number,
    required: true
  }
})

defineEmits(['play', 'pause', 'next', 'previous', 'reset', 'speed-change'])
</script>

<style scoped>
.animation-controls {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  flex-wrap: wrap;
  padding: 0.75rem;
}

.control-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.5rem 1rem;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 6px;
  color: rgba(255, 255, 255, 0.9);
  font-size: 0.875rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  min-width: 2.5rem;
}

.control-btn:hover:not(:disabled) {
  background: rgba(255, 255, 255, 0.1);
  border-color: rgba(255, 255, 255, 0.2);
  transform: translateY(-1px);
}

.control-btn:active:not(:disabled) {
  transform: translateY(0);
}

.control-btn:disabled {
  opacity: 0.3;
  cursor: not-allowed;
}

.control-btn:focus-visible {
  outline: 2px solid #0092c8;
  outline-offset: 2px;
}

.play-btn {
  min-width: 5rem;
  background: rgba(34, 197, 94, 0.2);
  border-color: rgba(34, 197, 94, 0.5);
  color: #22c55e;
}

.play-btn:hover:not(:disabled) {
  background: rgba(34, 197, 94, 0.3);
  border-color: rgba(34, 197, 94, 0.6);
}

.play-btn.playing {
  background: rgba(251, 191, 36, 0.2);
  border-color: rgba(251, 191, 36, 0.5);
  color: #fbbf24;
}

.play-btn.playing:hover {
  background: rgba(251, 191, 36, 0.3);
  border-color: rgba(251, 191, 36, 0.6);
}

.btn-icon {
  font-size: 1rem;
  line-height: 1;
}

.btn-text {
  font-size: 0.875rem;
}

.speed-control {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.speed-label {
  font-size: 0.875rem;
  color: rgba(255, 255, 255, 0.7);
}

.speed-select {
  padding: 0.5rem;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 6px;
  color: rgba(255, 255, 255, 0.9);
  font-size: 0.875rem;
  cursor: pointer;
  transition: all 0.2s ease;
}

.speed-select:hover {
  background: rgba(255, 255, 255, 0.1);
  border-color: rgba(255, 255, 255, 0.2);
}

.speed-select:focus-visible {
  outline: 2px solid #0092c8;
  outline-offset: 2px;
}

/* Responsive adjustments */
@media (max-width: 640px) {
  .animation-controls {
    gap: 0.375rem;
  }

  .control-btn {
    padding: 0.375rem 0.75rem;
    font-size: 0.813rem;
  }

  .play-btn {
    min-width: 4rem;
  }

  .speed-label {
    display: none;
  }
}
</style>
