export interface Author {
  id: number
  nick: string
}

export interface Debate {
  id: number
  title: string
  description: string | null
  category: string | null
  author?: Author
  status: string
  image_url: string | null
  image_credit?: string | null
  video_file_url: string | null
  video_url: string | null
  sources?: Array<{ name: string; url: string }>
  messages_count?: number
  created_at: string
  updated_at: string
}

export interface VoteTopic {
  id: number
  title: string
  description: string | null
  author?: Author
  target_signatures: number
  signatures_count: number
  progress: number | null
  deadline: string | null
  status: string
  created_at: string
}

export interface DebateMessage {
  id: number
  debate_id: number
  user?: Author
  content: string
  parent_id: number | null
  created_at: string
}

export interface CommentThread {
  message: DebateMessage
  children: CommentThread[]
}

export interface AuthUser {
  id: number
  nick: string
  email: string
  department: string | null
  email_verified_at: string | null
  is_admin?: boolean
}

export interface AdminMonthlyPoint {
  month: string
  label: string
  total: number
}

export interface AdminDebateStat {
  id: number
  title: string
  messages_count: number
}

export interface AdminVoteReached {
  id: number
  title: string
  signatures_count: number
  target_signatures: number
}

export interface AdminPeriodStats {
  month: string
  month_label: string
  from?: string
  from_label?: string
  comments_this_month: number
  users_this_month: number
  militants_this_month: number
  votes_reached_goal: number
  most_commented_debate: AdminDebateStat | null
  top_debates: AdminDebateStat[]
  votes_reached: AdminVoteReached[]
  comments_by_month: AdminMonthlyPoint[]
  users_by_month: AdminMonthlyPoint[]
  militants_by_month: AdminMonthlyPoint[]
  leaders?: AdminLeaderStat[]
  departments?: AdminDepartmentStat[]
  unassigned_users?: number
  spectrum?: AdminSpectrumSide[]
  cleavages?: AdminCleavage[]
}

export interface AdminLeaderStat {
  id: number | null
  nick: string
  name: string
  department: string | null
  messages_count: number
  signatures_count: number
  suggestions_count: number
  accepted_suggestions_count: number
  debates_touched: number
  score: number
  side: 'izquierda' | 'centro' | 'derecha'
  sample: boolean
}

export interface AdminDepartmentStat {
  name: string
  slug: string
  users: number
  militants: number
  comments: number
  signatures: number
  suggestions: number
  leaders: AdminLeaderStat[]
}

export interface AdminSpectrumSide {
  key: 'izquierda' | 'centro' | 'derecha'
  label: string
  percent: number
  people: number
  sample: boolean
}

export interface AdminCleavage {
  key: string
  label: string
  left: string
  right: string
  left_percent: number
  right_percent: number
  sample: boolean
}

export interface AdminSummary {
  debates: number
  users: number
  militants: number
  militants_pending: number
  vote_topics: number
  signatures: number
  suggestions_pending: number
  stats: AdminPeriodStats
}

export interface Suggestion {
  id: number
  type: 'debate' | 'vote'
  title: string
  description: string
  category: string | null
  target_signatures: number | null
  status: 'pending' | 'accepted' | 'rejected'
  admin_note: string | null
  debate_id: number | null
  vote_topic_id: number | null
  user?: Author
  created_at: string
}

export interface AdminUser {
  id: number
  nick: string
  name: string
  email: string
  department: string | null
  is_admin: boolean
  messages_count?: number
  signatures_count?: number
  debates_count?: number
  suggestions_count?: number
  created_at: string
}

export interface AdminMilitant {
  id: number
  full_name: string
  ci: string
  email: string
  phone: string
  city: string
  department: string
  birth_year: number
  status: 'pending' | 'active' | 'rejected'
  card_number: string | null
  created_at: string
}

export interface AdminSignature {
  id: number
  vote_topic_id: number
  user?: {
    id: number | null
    nick: string | null
    email: string | null
  }
  created_at: string
}

export interface Paginated<T> {
  data: T[]
  meta?: {
    current_page: number
    last_page: number
    total: number
  }
}
