/**
 * Hierarchical Graph Layout Algorithm
 *
 * Calculates node positions using multi-root topological sorting (BFS).
 * Arranges nodes in levels based on dependency depth, then distributes
 * them horizontally within each level.
 */

/**
 * Calculate hierarchical layout positions for graph nodes
 *
 * @param {Array} nodes - Array of node objects with id property
 * @param {Array} edges - Array of edge objects with from/to properties
 * @returns {Map} Map of node ID → {x, y} positions (0-100 coordinate system)
 */
export function calculateGraphLayout(nodes, edges) {
  // Step 1: Build adjacency structures
  const inDegree = new Map()
  const outEdges = new Map()
  const parents = new Map()

  // Initialize structures
  nodes.forEach(node => {
    inDegree.set(node.id, 0)
    outEdges.set(node.id, [])
    parents.set(node.id, [])
  })

  // Build dependency graph
  edges.forEach(edge => {
    outEdges.get(edge.from).push(edge.to)
    parents.get(edge.to).push(edge.from)
    inDegree.set(edge.to, inDegree.get(edge.to) + 1)
  })

  // Step 2: Assign levels using BFS from multiple roots
  const levels = new Map()
  const queue = []
  let maxLevel = 0

  // Find all root nodes (no dependencies)
  nodes.forEach(node => {
    if (inDegree.get(node.id) === 0) {
      levels.set(node.id, 0)
      queue.push(node.id)
    }
  })

  // BFS to assign dependency levels
  while (queue.length > 0) {
    const current = queue.shift()
    const currentLevel = levels.get(current)

    outEdges.get(current).forEach(child => {
      // Assign child to currentLevel + 1 (or deeper if already assigned)
      const childLevel = Math.max(
        levels.get(child) || 0,
        currentLevel + 1
      )
      levels.set(child, childLevel)
      maxLevel = Math.max(maxLevel, childLevel)

      // Decrement in-degree and enqueue if all parents processed
      inDegree.set(child, inDegree.get(child) - 1)
      if (inDegree.get(child) === 0) {
        queue.push(child)
      }
    })
  }

  // Step 3: Group nodes by level
  const levelGroups = new Map()
  nodes.forEach(node => {
    const level = levels.get(node.id)
    if (!levelGroups.has(level)) {
      levelGroups.set(level, [])
    }
    levelGroups.get(level).push(node)
  })

  // Step 4: Calculate Y positions (vertical - based on level)
  const VERTICAL_PADDING = 12
  const VERTICAL_SPACING = (100 - 2 * VERTICAL_PADDING) / Math.max(1, maxLevel)

  // Step 5: Calculate X positions (horizontal - distribute within level)
  const HORIZONTAL_PADDING = 10
  const positions = new Map()

  // Type order for consistent visual grouping
  const typeOrder = {
    account: 0,
    contact: 1,
    opportunity: 2,
    lead: 3
  }

  for (let level = 0; level <= maxLevel; level++) {
    const nodesInLevel = levelGroups.get(level) || []
    const nodeCount = nodesInLevel.length

    if (nodeCount === 0) continue

    const y = VERTICAL_PADDING + level * VERTICAL_SPACING

    // Sort nodes by SObject type for visual grouping
    const sorted = [...nodesInLevel].sort((a, b) => {
      const aType = a.id.replace(/[0-9]/g, '')
      const bType = b.id.replace(/[0-9]/g, '')
      return (typeOrder[aType] || 99) - (typeOrder[bType] || 99)
    })

    // Distribute horizontally with centering
    const availableWidth = 100 - 2 * HORIZONTAL_PADDING

    if (nodeCount === 1) {
      // Single node - center it
      positions.set(sorted[0].id, { x: 50, y })
    } else {
      // Multiple nodes - distribute evenly
      const spacing = availableWidth / (nodeCount - 1)
      sorted.forEach((node, index) => {
        const x = HORIZONTAL_PADDING + index * spacing
        positions.set(node.id, { x, y })
      })
    }
  }

  // Step 6: Apply force-directed adjustments to improve layout
  applyForceDirectedAdjustments(positions, edges, levels, maxLevel)

  return positions
}

/**
 * Apply subtle force-directed adjustments to reduce edge crossings
 * and align parent-child relationships horizontally
 *
 * @param {Map} positions - Map of node ID → {x, y}
 * @param {Array} edges - Array of edge objects
 * @param {Map} levels - Map of node ID → level number
 * @param {number} maxLevel - Maximum level number
 */
function applyForceDirectedAdjustments(positions, edges, levels, maxLevel) {
  const ITERATIONS = 8
  let attractionStrength = 0.15
  const MIN_X = 10
  const MAX_X = 90

  for (let iter = 0; iter < ITERATIONS; iter++) {
    const forces = new Map()

    // Calculate attractive forces along edges (parent-child alignment)
    edges.forEach(edge => {
      const fromPos = positions.get(edge.from)
      const toPos = positions.get(edge.to)

      if (!fromPos || !toPos) return

      // Only adjust X (horizontal) position, keep Y (level) fixed
      const dx = fromPos.x - toPos.x
      const force = dx * attractionStrength

      // Only apply if nodes are on adjacent levels (preserve hierarchy)
      const fromLevel = levels.get(edge.from)
      const toLevel = levels.get(edge.to)

      if (toLevel === fromLevel + 1) {
        forces.set(edge.to, (forces.get(edge.to) || 0) + force)
      }
    })

    // Apply forces with bounds checking
    forces.forEach((force, nodeId) => {
      const pos = positions.get(nodeId)
      const newX = Math.max(MIN_X, Math.min(MAX_X, pos.x + force))
      positions.set(nodeId, { x: newX, y: pos.y })
    })

    // Reduce force strength over iterations for convergence
    attractionStrength *= 0.9
  }
}
