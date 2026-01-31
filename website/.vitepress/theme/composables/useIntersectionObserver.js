/**
 * Intersection Observer Composable for Auto-Play
 *
 * Triggers a callback when an element enters the viewport.
 * Designed for one-time auto-play functionality.
 */

import { ref, onMounted, onUnmounted } from 'vue'

/**
 * Auto-play composable using Intersection Observer
 *
 * @param {Ref} elementRef - Vue ref to the element to observe
 * @param {Function} onEnterViewport - Callback to trigger when element enters viewport
 * @returns {Object} - { hasTriggered: Ref<boolean> }
 */
export function useAutoPlay(elementRef, onEnterViewport) {
  const hasTriggered = ref(false)
  let observer = null

  onMounted(() => {
    const element = elementRef.value
    if (!element) return

    // Check if element is already in viewport on mount
    const rect = element.getBoundingClientRect()
    const viewportHeight = window.innerHeight || document.documentElement.clientHeight
    const viewportWidth = window.innerWidth || document.documentElement.clientWidth

    const isInViewport = (
      rect.top >= 0 &&
      rect.left >= 0 &&
      rect.bottom <= viewportHeight &&
      rect.right <= viewportWidth &&
      // Check if at least 30% is visible
      rect.top <= viewportHeight * 0.7
    )

    if (isInViewport && !hasTriggered.value) {
      // Already in viewport - trigger immediately with small delay
      // Delay ensures DOM is fully rendered and animations are ready
      setTimeout(() => {
        if (!hasTriggered.value) {
          hasTriggered.value = true
          onEnterViewport()
        }
      }, 300)
      return
    }

    // Set up observer for future viewport entries
    observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          // Trigger only once, only when entering (not leaving)
          if (entry.isIntersecting && !hasTriggered.value) {
            hasTriggered.value = true
            onEnterViewport()

            // Disconnect observer after first trigger to save resources
            if (observer) {
              observer.disconnect()
              observer = null
            }
          }
        })
      },
      {
        root: null,           // Use viewport as root
        threshold: 0.3,       // Trigger when 30% of element is visible
        rootMargin: '0px'     // No margin adjustment
      }
    )

    observer.observe(element)
  })

  onUnmounted(() => {
    if (observer) {
      observer.disconnect()
      observer = null
    }
  })

  return {
    hasTriggered
  }
}
