module ApplicationHelper
  def status_badge_class(status)
    case status.to_s
    when "pending", "queued"
      "bg-slate-100 text-slate-700"
    when "processing"
      "bg-amber-100 text-amber-700"
    when "sent", "completed"
      "bg-emerald-100 text-emerald-700"
    when "failed"
      "bg-rose-100 text-rose-700"
    else
      "bg-slate-100 text-slate-700"
    end
  end
end
