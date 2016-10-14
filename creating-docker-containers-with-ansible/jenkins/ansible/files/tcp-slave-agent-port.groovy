import hudson.model.*;
import jenkins.model.*;

Thread.start {
  sleep 10000
  println "--> setting agent port for jnlp"
  def port = System.getenv('JENKINS_SLAVE_AGENT_PORT') ?: "50000"
  Jenkins.instance.setSlaveAgentPort(port.toInteger())
  Jenkins.instance.save()
  println "--> setting agent port for jnlp... done"
}
